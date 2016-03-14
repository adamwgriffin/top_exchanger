#!/usr/bin/env ruby

require 'optparse'
require "top_exchanger"

MAPPING = File.join(File.dirname(File.expand_path(__FILE__)), "mapping.yml")
DEFAULT_OUTPUT_NAME = "moxi_import-outlook_2010-13.csv"

def error(usage, message)
  puts message if message
  puts usage
  exit(-1)
end

# configure command line options
options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "top_exchanger: translate Top Producer export files to Office 365 format
  Usage: top_exchanger [options] inputfile [outputfile]"
  opts.on( "-h", "--help", "Display this screen" ) do
     puts opts
     exit
  end
  opts.on("-e ENCODING", "--encoding=ENCODING", "Specify the encoding of the input file, if not UTF-8") do |encoding|
    options[:encoding] = encoding
  end
end
optparse.parse!
# check if files were specified, handle errors
error(optparse, "No file specified") if ARGV.empty?
export_file = ARGV.shift # this is the file we're going to translate
error(optparse, "#{export_file} doesn't exist") unless File.file?(export_file)
# this is the translated file we're going to ouput, give it a name if not specified
import_file = ARGV.shift || DEFAULT_OUTPUT_NAME
# try to guess text encoding. THIS THING IS GUESSING BINARY FOR SOME REASON
# encoding = `file -b --mime-encoding #{export_file}`.chomp

translator = TopProducerO365.new(import_file, export_file)
# TODO: must add option in o365_translator.rb to skip blank names
options[:remove_control_chars] = true
translator.translate(options)
