require 'csv'
require 'yaml'
require 'active_support/core_ext/hash/slice'

module O365Translator

  class Base

    def initialize(import_file, export_file, mapping)
      @mapping = YAML.load_file(mapping) # full path to mapping.yml file
      @import_headers = @mapping.keys
      @export_file = export_file # this is the file we're going to translate to o365 format
      # open output file & add headers
      @output = CSV.open(import_file, "wb") # this is the translated file we're going to ouput
      @output << @import_headers
    end

    def translate!(encoding)
      trancode = encoding ? "#{encoding}:UTF-8" : nil
      CSV.foreach(@export_file, headers: true, encoding: trancode) do |contact|
        new_contact = CSV::Row.new(@import_headers , [])
        @mapping.each do |exchange_col, map_col|
          if map_col.is_a? Hash
            # map_col['map'] is an array of fields. The * splat gives a list of strings for slice()
            field_hash = contact.to_hash.slice( *map_col['map'] )
            new_contact[exchange_col] = send( map_col['method'], field_hash )
          else
            new_contact[exchange_col] = contact[map_col]
          end
        end
        @output << new_contact
      end
    rescue CSV::MalformedCSVError => e
     raise "Error parsing CSV: #{e}"
    end

  end

end