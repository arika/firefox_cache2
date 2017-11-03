# frozen_string_literal: true

module FirefoxCache2
  # Firefox cache2 entry file class
  class Entry
    include Enumerable

    HASH_CHUNK_SIZE = 256 * 1024

    @regexp_cache = {}

    class << self
      def regexp_with_cache(name)
        @regexp_cache[name] ||= yield
      end
    end

    attr_reader :path, :content_type, :content_encoding, :content_size,
                :version, :fetch_count, :last_fetched_at, :last_modified_at,
                :expire_at, :frecency, :key, :key_tags, :attributes

    def initialize(path)
      @path = path
      load_metadata
    end

    def to_h
      {
        path: path,
        content_type: content_type,
        content_encoding: content_encoding,
        content_size: content_size,
        version: version,
        fetch_count: fetch_count,
        last_fetched_at: last_fetched_at,
        last_modified_at: last_modified_at,
        expire_at: expire_at,
        frecency: frecency,
        key: key,
        key_tags: key_tags,
        attributes: attributes,
      }
    end

    def each(&block)
      to_h.each(&block)
    end

    def content
      @content ||= load_content
    end

    private

    def load_content
      open_file do |io|
        io.seek(0, IO::SEEK_SET)
        @content = io.read(content_size)
      end
    end

    def load_metadata
      open_file do |io|
        @content_size = read_content_size(io)
        data = read_raw_metadata(io)

        @version, @fetch_count, last_fetched_at_i, last_modified_at_i,
          @frecency, expire_at_i, key_length, flags = data.unpack('N8')

        if @version > 1
          @flags = flags
          num_fileds = 8
        else
          num_fileds = 7
        end
        raw_key, raw_attrs = data.unpack("@#{4 * num_fileds}a#{key_length}xa*")

        @last_fetched_at = Time.at(last_fetched_at_i)
        @last_modified_at = Time.at(last_modified_at_i)
        @expire_at = Time.at(expire_at_i)
        @flags = nil unless @version > 1

        @key, @key_tags = parse_raw_key(raw_key)
        @attributes = parse_raw_attrs(raw_attrs)

        @content_type = extract_response_header_value('Content-Type')
        @content_encoding = extract_response_header_value('Content-Encoding')
      end
    end

    def parse_raw_key(raw_key)
      key = raw_key
      tags = []
      while /\A([pba]|i[^,]*|[ -~&&[^:]](?:,,|[^,])*),/o =~ key
        tags.push $1
        key = $'
      end

      [key.sub(/\A:/o, ''), tags]
    end

    def parse_raw_attrs(raw_attrs)
      pairs = raw_attrs.split(/\0/o)
      pairs.push '' if pairs.size.odd?
      attrs = Hash[*pairs]

      # if attrs['security-info']
      #   attrs['security-info'] = attrs['security-info'].unpack('m').first
      # end

      attrs
    end

    def read_content_size(io)
      io.seek(-4, IO::SEEK_END)
      io.read.unpack('N').first
    end

    def read_raw_metadata(io)
      num_hash_chunks, m = content_size.divmod(HASH_CHUNK_SIZE)
      num_hash_chunks += 1 if m > 0

      io.seek(content_size + 4 + num_hash_chunks * 2, IO::SEEK_SET)
      io.read[0...-4]
    end

    def extract_response_header_value(name)
      heads = attributes['response-head']
      regexp = self.class.regexp_with_cache(name) { /^#{Regexp.quote(name)}:[ \t]*([^\r\n]+)/i }
      return unless heads && regexp =~ heads
      $1
    end

    def open_file
      File.open(path, 'r', encoding: 'BINARY') do |io|
        yield(io)
      end
    end
  end
end
