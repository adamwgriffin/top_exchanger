require 'csv'
require 'yaml'
require 'active_support/core_ext/hash/slice'
require 'pry-debugger'

# TODO: change module name to be more generic
module O365Translator

  class Base

    attr_reader :import_file, :export_file, :mapping

    def initialize(import_file, export_file, mapping_file, csv_input_opts={}, csv_output_opts={})
      @mapping = YAML.load_file(mapping_file)
      @import_headers = @mapping.keys
      @export_file = export_file # this is the original file we're going to translate to o365 format
      @output = CSV.open(import_file, "wb", csv_output_opts) # this is the translated file we're going to ouput
      @output << @import_headers
    end

    def blank_row?(row)
      ( row.fields  - ["", nil] ).empty?
    end

    def translate(opts = {})
      opts = {encoding: nil, skip_blank: nil}.merge(opts) # TODO: move encoding out, keep skip_blank
      transcode = opts[:encoding] ? "#{opts[:encoding] }:UTF-8" : nil # TODO: encoding should be passed down from application, move this code
      CSV.foreach(@export_file, headers: true, encoding: transcode) do |contact|
        new_contact = CSV::Row.new(@import_headers, [])
        @mapping.each do |exchange_col, map_col|
          # TODO: this option should probably be moved to top_exchanger.rb and put into mapping config
          if map_col == "Contact Notes" && opts[:remove_control_chars] && !(contact[map_col] == nil)
            # remove invisible control characters such as \u0001 that cause import to fail in desktop version of Outlook
            contact[map_col] = contact[map_col].gsub(/[[:cntrl:]]/, ' ')
          end
          if map_col.is_a? Hash
            # map_col['map'] is an array of fields. The * splat gives a list of strings for slice()
            field_hash = contact.to_hash.slice( *map_col['map'] )
            # call the method named in the config that will be defined in a subclass of this module
            new_contact[exchange_col] = send( map_col['method'], field_hash )
          else
            new_contact[exchange_col] = contact[map_col]
          end
        end
        @output << new_contact unless ( opts[:skip_blank] && blank_row?(new_contact) )
      end
      # must explicitly close file, otherwise the buffer may not be flushed & when we try to read it later it will not be the whole file
      @output.close
    rescue CSV::MalformedCSVError => e
     raise "Error parsing CSV: #{e}"
    end

  end

end
