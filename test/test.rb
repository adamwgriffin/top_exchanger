#!/usr/bin env ruby

require "top_exchanger"

top_producer_file = File.join(File.dirname(File.expand_path(__FILE__)), "export", "tp_export-partial.csv")
office365_export_file = File.join(File.dirname(File.expand_path(__FILE__)), "export_test.csv")

translator = TopProducerO365.new(office365_export_file, top_producer_file)
translator.translate()
