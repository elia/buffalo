require 'ostruct'
require 'tilt'
require 'pdfkit'

module Buffalo
  class Bill
    def initialize dir
      @dir = dir
    end

    attr_reader :dir

    def load_info type=nil, id
      hash = YAML.load_file(File.expand_path("#{dir}/#{type}/#{id}.yml"))
      hash['id'] = id
      OpenStruct.new hash
    end

    def make_all_invoices
      Dir[File.expand_path("#{dir}/invoices/*.yml")].each { |i| make_invoice i }
    end

    def make_invoice invoice_file
      invoice_id = File.basename invoice_file, '.yml'
      invoice        = load_info(:invoices, invoice_id)
      invoice.id     = invoice_id
      invoice.me     = load_info(:me)
      invoice.client = load_info(:clients, invoice.client)

      invoice.items = invoice.items.map do |item|
        OpenStruct.new item
      end

      template = Tilt.new("./templates/#{invoice.template}.haml")
      html = template.render(invoice)
      pdf  = PDFKit.new(html, :page_size => 'A4').to_pdf

      html_file = "./output/#{invoice.id}-#{invoice.client.id}.html"
      pdf_file  = "./output/#{invoice.id}-#{invoice.client.id}.pdf"

      File.open(html_file, 'w') {|f| f << html}
      File.open(pdf_file,  'w') {|f| f << pdf }

      system 'open', File.dirname(html_file)
    end

    # def watch!
    #   require 'watchr'
    #   watch("#{dir}")
    # end
  end
end

