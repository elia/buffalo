require 'ostruct'
require 'tilt'
require 'pdfkit'
require 'yaml'

module Buffalo
  class Bill
    def initialize dir
      @dir = dir
    end

    attr_reader :dir

    def load_info type, id=nil
      path = [dir, type, id].compact.join('/')
      hash = YAML.load_file(File.expand_path("#{path}.yml"))
      hash['id'] = id
      OpenStruct.new hash
    end

    def make_all_invoices
      Dir[File.expand_path("#{dir}/invoices/*.yml")].each { |i| make_invoice i }
      # system 'open', File.dirname(html_file)
    end

    def make_invoice invoice_file
      log("Generating invoice from: #{File.basename invoice_file}")
      invoice_id = File.basename invoice_file, '.yml'
      invoice        = load_info(:invoices, invoice_id)
      invoice.id     = invoice_id
      invoice.me     = load_info(:me, invoice.me)
      invoice.client = load_info(:clients, invoice.client)

      invoice.items = invoice.items.map do |item|
        OpenStruct.new item
      end

      template = Tilt.new("./templates/#{invoice.template}.haml")
      output_base = "./output/#{invoice.me.id}-#{invoice.id}-#{invoice.client.id}"

      html = nil # keep it for the pdf

      render_file output_base, :html do
        html = template.render(invoice)
      end

      # render_file output_base, :pdf do
      #   PDFKit.new(html, :page_size => 'A4').to_pdf
      # end
    end

    def render_file base, type
      log("Generating #{type}...")
      contents = yield
      log("Writing #{type}...")
      file_name = "#{base}.#{type}"
      File.open(file_name, 'w') {|f| f << contents}
    end

    # def watch!
    #   require 'watchr'
    #   watch("#{dir}")
    # end

    def log message
      puts message
    end
  end
end

