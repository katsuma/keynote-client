require 'unindent'
require 'keynote/util'

module Keynote
  module ArrayMethods
    def <<(slide)
      raise ArgumentError.new "master_slide_name is not specified" unless slide.base_slide

      title = slide.title.gsub(/(\r\n|\r|\n)/) { '\\n' }
      body  = slide.body.gsub(/(\r\n|\r|\n)/) { '\\n' }

      result = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{self.document.id}")
        var masterSlide = doc.masterSlides.whose({name: "#{slide.base_slide}"}).first
        var slide = Keynote.Slide({ baseSlide: masterSlide })
        doc.slides.push(slide)
        slide = doc.slides()[doc.slides().length - 1]
        slide.defaultTitleItem.objectText = "#{title}"
        slide.defaultBodyItem.objectText = "#{body}"

        var slideResult = {
          body_showing: slide.bodyShowing(),
          skipped: slide.skipped(),
          slide_number: slide.slideNumber(),
          title_showing: slide.titleShowing(),
          body: slide.defaultBodyItem.objectText(),
          title: slide.defaultTitleItem.objectText(),
          presenter_notes: slide.presenterNotes(),
          transition_properties: slide.transitionProperties()
        }
        JSON.stringify(slideResult)
      APPLE

      slide.document = self.document
      slide.body_showing = result["body_showing"]
      slide.skipped = result["skipped"]
      slide.slide_number = result["slide_number"]
      slide.title_showing = result["title_showing"]
      slide.presenter_notes = result["presenter_notes"]
      slide.transition_properties = result["transition_properties"]

      super
    end
  end

  class SlideArray < Array
    prepend ArrayMethods
    attr_accessor :document

    include Keynote::Util
  end
end
