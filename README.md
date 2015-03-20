# TopExchanger

Translate Top Producer export files to Office 365 format. This Gem parses a Top Producer CSV export file and maps the appropriate fields to a new CSV in the format that the Office 365 contact importer understands. The file exported from Top Producer needs to be in the format they call "Contact record and all associated items".

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

    translator = TopProducerO365.new("/path/to/office365/file.csv", "/path/to/top_producer/file.csv", custom_mapping.yml)
    translator.translate(skip_blank: true)
