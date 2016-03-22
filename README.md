# TopExchanger

Translate Top Producer export files to Exchange format. This Gem parses a Top Producer CSV export file and maps the appropriate fields to a new CSV in the format that Exchange understands.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'top_exchanger', :github => 'adamwgriffin/top_exchanger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ git clone https://github.com/adamwgriffin/top_exchanger.git
    $ gem build top_exchanger.gemspec
    $ gem install top_exchanger

## Usage

    require "top_exchanger"

    translator = TopProducerExchange.new(import_file="/path/to/exchange/file.csv", export_file="/path/to/top_producer/file.csv", options={option: 'hash'})
    translator.translate(options={option: 'hash'})
