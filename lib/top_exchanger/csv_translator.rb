require 'csv'
require 'yaml'
require 'active_support/core_ext/hash/slice'

module CsvTranslator

  class Base

    attr_reader :import_file, :export_file, :mapping

    def initialize(import_file, export_file, mapping_file, opts={})
      opts = {csv_input_opts: {headers: true}, replace_chars: nil}.merge(opts) # merge default options with options passed in
      @mapping = YAML.load_file(mapping_file)
      @import_headers = @mapping.keys
      @export_file = export_file # this is the original file we're going to translate to o365 format
      @output = CSV.open(import_file, "wb", opts[:csv_output_opts]) # this is the translated file we're going to output
      @csv_input_opts = opts[:csv_input_opts]
      @output << @import_headers
      @replace_chars = opts[:replace_chars]
      @skip_dups = opts[:skip_dups]
    end

    def blank_row?(row)
      ( row.fields  - ["", nil] ).empty?
    end

    def same_field_values?(previous, current)
      previous.include? current.to_hash.slice(*@skip_dups).values
    end

    def dup_fields_present?(contact)
      # some TP file formats may not include the field(s) that we use to check dups
      contact.to_hash.slice(*@skip_dups).length > 0
    end

    def translate(opts={})
      opts = {skip_blank: false}.merge(opts)
      previous_contacts = []
      CSV.foreach(@export_file, @csv_input_opts) do |contact|
        if @skip_dups && dup_fields_present?(contact)
          next if same_field_values?(previous_contacts, contact)
          # add an array of the field values we use to determine what is a dup to previous_contacts to check later
          previous_contacts << contact.to_hash.slice(*@skip_dups).values
        end
        new_contact = CSV::Row.new(@import_headers, [])
        @mapping.each do |exchange_col, map_col|
          if map_col.is_a? Hash
            # map_col['map'] is an array of fields. The * splat gives a list of strings for slice()
            field_hash = contact.to_hash.slice( *map_col['map'] )
            # call the method named in the config that will be defined in a subclass of this module
            contact[map_col] = send( map_col['method'], field_hash )
          end
          if @replace_chars && @replace_chars[:fields].include?(map_col)
            contact[map_col] = contact[map_col].to_s.gsub(@replace_chars[:find], @replace_chars[:replace])
          end
          new_contact[exchange_col] = contact[map_col]
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
