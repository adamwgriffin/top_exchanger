#!/usr/bin/env ruby

require 'optparse'
require "top_exchanger"
require 'pry-debugger'

DEFAULT_OUTPUT_NAME = "moxi_import-outlook_2010-13.csv"

def error(usage, message)
  puts message if message
  puts usage
  exit(-1)
end

# configure command line options
options = {}
csv_input_options = {}
csv_output_options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "top_exchanger: translate Top Producer export files to Office 365 format
  Usage: top_exchanger [options] inputfile [outputfile]"
  opts.on( "-h", "--help", "Display this screen" ) do
     puts opts
     exit
  end
  opts.on("-e ENCODING", "--encoding=ENCODING", "Specify that you wish to transcode from one format to another, option must be in the following format: ISO-8859-15:UTF-8. Default is UTF-8.") do |encoding|
    csv_input_options[:encoding] = encoding
  end
  opts.on("-r ROW_SEPARATOR", "--row-separator=ROW_SEPARATOR", 'Specify the the row seperator (line ending character) that should be used in the resulting file: \r\n for Windows, \n for *nix') do |row_separator|
    csv_output_options[:row_sep] = row_separator
  end
end
optparse.parse!
# check if files were specified, handle errors
error(optparse, "No file specified") if ARGV.empty?
export_file = ARGV.shift # this is the file we're going to translate
error(optparse, "#{export_file} doesn't exist") unless File.file?(export_file)
# this is the translated file we're going to ouput, give it a name if not specified
import_file = ARGV.shift || DEFAULT_OUTPUT_NAME

translator = TopProducerToExchange.new(import_file, export_file, mapping_file=nil, csv_input_opts=csv_input_options, csv_output_opts=csv_output_options)

translator.translate(options)
