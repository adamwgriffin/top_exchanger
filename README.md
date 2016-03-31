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

    translator = TopProducerExchange.new(import_file="/path/to/exchange/file.csv", export_file="/path/to/top_producer/file.csv", opts={option: 'hash'})
    translator.translate(opts={option1: 'option', option2: 'option'})

## Methods

    new(import_file, export_file, opts=Hash.new)

This constructor takes a path to an import_file, which is the path to a file that will be created and ouput as an exchange import file once the conversion is done. It also takes the path to an export file, which is the Top Producer export file that we want to convert to Exchange. The thrid argument is an options has for optional arguments. These are the options that can be passed in:
	
    replace_chars => {fields: ["Array", "of", "Field", "Names"], find: /Regex/, replace: 'replacement string'}

Provide and array of fields that you want to replace text in. This is useful if you want to remove strange characters that cause problems with the import.

    csv_input_opts => {headers: true}

These are options that are passed into an instance of a CSV class from the Ruby standard library (http://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html#method-c-new). These options are passed in when the translator is reading each line from the Top Producer file that in intended to be converted. They correspond to options you could pass into CSV.new().

    csv_output_opts => {force_quotes: true, row_sep: "\r\n"}

These are also options that are passed into an instance of a CSV class. These options are passed into the converted CSV file that we output once the Top Producer file has been translated. They correspond to options you could pass into CSV.new().

    translate(opts=Hash.new)

This method opens the Top Producer CSV file, reads through each line and maps each column to it's equivalent Exchange column name. It opens the new file to be converted and adds the new lines to it in CSV format. There is an options hash that can be passed into this method but no options have actually been implemented yet. 
