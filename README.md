# I18n::JSON

[![](https://github.com/fnando/i18n-json/workflows/tests/badge.svg)](https://github.com/fnando/i18n-json/actions?query=workflow%3Atests)

Export I18n translations to JSON. A perfect fit if you want to export
translations to JavaScript.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "i18n-json"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n-json

## Usage

About patterns:

- Patterns can use `*` as a wildcard and can appear more than once.
  - `*` will include everything
  - `*.messages.*`
- Patterns starting with `!` are excluded.
  - `!*.activerecord.*` will exclude all ActiveRecord translations.

The config file:

```yml
---
translations:
  - file: app/frontend/locales/en.json
    patterns:
      - "en.*"
      - "!en.*.activerecord.errors"

  - file: app/frontend/locales/:locale.json
    patterns:
      - "*"
```

The Ruby API:

```ruby
require "i18n-json"

I18nJSON.call(config_file: "config/i18n.yml")
I18nJSON.call(config: config)
```

The CLI API:

```console
$ i18n-json init --config config/i18n.yml
$ i18n-json export --config config/i18n.yml --require config/boot.rb
```

## Automatically export translations

### Using guard

You can also automatically export translations when file changes using
[guard-i18n-json](https://github.com/fnando/guard-i18n-json).

First, add the template to your `Guardfile` with the following command:

```console
$ bundle exec guard init i18n_json
```

Something like this will be added:

```ruby
guard(:i18n_json,
      run_on_start: true,
      config_file: "./config/i18n.yml",
      require_file: "./config/boot.rb") do
  watch(%r{^(app|config)/locales/.+\.(yml|po)$})
  watch(%r{^config/i18n.yml$})
  watch("Gemfile")
end
```

Configure file paths accordingly.

### Using listen

Create a file under `config/initializers/i18n.rb` with the following content:

```ruby
# frozen_string_literal: true

require "i18n-json/listen"

I18nJSON.listen
```

The code above will watch for changes based on `config/i18n.yml` and
`config/locales`. You can customize these options with
`I18nJSON.listen(config_file: "config/i18n.yml", locales_dir: "config/locales")`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fnando/i18n-json. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the I18n::Json project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/i18n-json/blob/master/CODE_OF_CONDUCT.md).
