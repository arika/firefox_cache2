# frozen_string_literal: true

require 'firefox_cache2/version'
require 'firefox_cache2/entry'
require 'ostruct'
require 'fileutils'
require 'uri'
require 'json'
require 'optparse'

# Firefox cache2 module
#
# ref:
# * https://github.com/JamesHabben/FirefoxCache2
# * http://encase-forensic-blog.guidancesoftware.com/2015/02/firefox-cache2-storage-breakdown.html
module FirefoxCache2
  BASE_DIRS = [
    ENV['XDG_CACHE_HOME'] ? "#{ENV['XDG_CACHE_HOME']}/mozilla/firefox" : '~/.cache/mozilla/firefox',
    '~/Library/Caches/Firefox/Profiles',
  ].freeze

  module_function

  def base_dir
    BASE_DIRS.map {|dir| File.expand_path(dir) }.detect {|dir| File.directory?(dir) }
  end

  def profile_dirs(profile_glob = '*')
    Dir.glob("#{base_dir}/*.#{profile_glob}")
  end

  def entries_dir(profile_name)
    profile_dir = profile_dirs(profile_name).first
    return unless profile_dir
    "#{profile_dir}/cache2/entries"
  end
end
