require 'keynote/util'

module Keynote
  class Slide
    extend Keynote::Util
    include Keynote::Util

    attr_accessor(
      :document,
      :base_slide,
      :body_showing,
      :skipped,
      :slide_number,
      :title_showing,
      :body,
      :title,
      :presenter_notes,
      :transition_properties,
    )

    def initialize(base_slide = nil, arguments = {})
      raise ArgumentError.new('base_slide is not given') unless base_slide

      @base_slide = base_slide
      arguments.each do |attr, val|
        send("#{attr}=", val)
      end
    end

    def title=(title)
      @title = title
      return unless @document && @slide_number

      result = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{@document.id}")
        var slide = doc.slides()[#{@slide_number - 1}]
        slide.defaultTitleItem.objectText = "#{title}"
        JSON.stringify({ result: true })
      APPLE
    end

    def body=(body)
      @body = body
      return unless @document && @slide_number

      result = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{@document.id}")
        var slide = doc.slides()[#{@slide_number - 1}]
        slide.defaultBodyItem.objectText = "#{body}"
        JSON.stringify({ result: true })
      APPLE
    end
  end
end
