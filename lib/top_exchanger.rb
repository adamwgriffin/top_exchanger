require "top_exchanger/version"
require "top_exchanger/o365_translator"

class TopProducerO365 < O365Translator::Base

  @@exchange_mapping_file = File.join(File.dirname(File.expand_path(__FILE__)), "top_exchanger", "mapping.yml")

  def initialize(import_file, export_file, mapping_file=@@exchange_mapping_file, csv_input_opts={}, csv_output_opts={})
    # merge/override any csv opts that were passed in with the defaults
    # using Windows line endings \r\n (CTRL + LF) because desktop Outlook does not like default \n
    csv_output_opts = {force_quotes: true, row_sep: "\r\n"}.merge(csv_output_opts)
    super(import_file, export_file, mapping_file, csv_input_opts, csv_output_opts)
  end

  def add_unit_num(unit, bldg)
    if unit
      unit_num = unit
      # some have Ste, other have #, some have nothing.
      # adding '#' to those that are numbers fixes 90% of these
      unit_num = '#' + unit if unit.match(/\A(\d)+\z/)
    end
    if (unit && bldg)
      unit_num = "#{unit_num}, #{bldg}"
    end
    if (bldg && !unit)
      unit_num = bldg
    end
    unit_num
  end

  def format_po_box(po_box)
    # if it's just a number add the rest
    if /\A[0-9]+\z/ =~ po_box
      return "PO Box #{po_box}"
    else
      return po_box
    end
  end

  def concat_street(fields)
    return format_po_box( fields["PO_Box"] ) if fields["PO_Box"] # use PO Box instead if we have it
    unit = add_unit_num( fields.delete("Suite No"), fields.delete("Bldg_Floor") ) # delete, so we don't use these twice
    street = fields.values << unit
    street.join(' ').strip.squeeze(' ') # concatenate street, no extra whitespace
  end

end
