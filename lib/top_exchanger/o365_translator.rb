require 'csv'
require 'yaml'
require 'active_support/core_ext/hash/slice'

module O365Translator

  class Base

    attr_reader :import_file, :export_file, :mapping

    def initialize(import_file, export_file, mapping_file)
      @mapping = YAML.load_file(mapping_file)
      @import_headers = @mapping.keys
      @export_file = export_file # this is the file we're going to translate to o365 format
      @import_file = import_file
      @output = CSV.open(@import_file, "wb") # this is the translated file we're going to ouput
      @output << @import_headers
    end

    def blank_row?(row)
      ( row.fields  - ["", nil] ).empty?
    end

    def translate(opts = {})
      opts = {encoding: nil, skip_blank: nil}.merge(opts)
      transcode = opts[:encoding] ? "#{opts[:encoding] }:UTF-8" : nil
      CSV.foreach(@export_file, headers: true, force_quotes: true, encoding: transcode) do |contact|
        new_contact = CSV::Row.new(@import_headers, [])
        @mapping.each do |exchange_col, map_col|
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
      # must explicitly close file, otherwise the buffer won't be flushed & when we try to read it later it will not be the whole file
      @output.close
    rescue CSV::MalformedCSVError => e
     raise "Error parsing CSV: #{e}"
    end

  end

end
