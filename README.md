# FirefoxCache2

## Installation

    $ gem install firefox_cache2

## Usage

This is aFirefox cache2 entry files utility.

All entries:

```
$ firefox_cache2
https://docs.ruby-lang.org/ja/search/css/smoothness/images/ui-bg_flat_75_ffffff_40x100.png (fetched at 2017-11-04 21:36:55 +0900, image/png 178 bytes)
http://www.ruby-lang.org/ja/ (fetched at 2017-11-04 21:36:41 +0900, text/html 3802 bytes)
https://docs.ruby-lang.org/ja/search/javascripts/jquery.min.js (fetched at 2017-11-04 21:36:55 +0900, application/javascript 27106 bytes)
http://www.ruby-lang.org/images/download-ruby-arrow@2x.png (fetched at 2017-11-04 21:36:39 +0900, image/png 1466 bytes)
https://docs.ruby-lang.org/ja/search/javascripts/jquery-ui.min.js (fetched at 2017-11-04 21:36:55 +0900, application/javascript 51823 bytes)
...
```

Entries mached to the regexp:

```
firefox_cache2 '\.ruby-lang\.org/(?:ja|en)'
```

Entries included in the specified profiles:

```
firefox_cache2 . foo bar
```

List URI only:

```
firefox_cache2 -U
```

Output as JSON:

```
firefox_cache2 -j
```

Other options:

```
firefox_cache2 -h
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arika/firefox_cache2.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
