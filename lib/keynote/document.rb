require 'unindent'
require 'keynote/theme'
require 'keynote/util'

module Keynote
  class Document
    extend Keynote::Util
    include Keynote::Util

    attr_accessor(
      :name,
      :slides,
      :master_slides,
      :slide_numbers_showing,
      :document_theme,
      :auto_loop,
      :auto_play,
      :auto_restart,
      :maximum_idle_duration,
      :current_slide,
      :height,
      :width,
      :file_path,
    )

    attr_reader :id

    DEFAULT_WIDTH = 1024
    DEFAULT_HEIGHT = 768
    WIDE_WIDTH = 1900
    WIDE_HEIGHT = 1080

    def initialize(arguments = {})
      @document_theme = arguments[:theme] || Theme.default
      @width = arguments.has_key?(:wide) && arguments[:wide] ? WIDE_WIDTH : DEFAULT_WIDTH
      @height = arguments.has_key?(:wide) && arguments[:wide] ? WIDE_HEIGHT : DEFAULT_HEIGHT
      @file_path = arguments[:file_path]

      result = Document.create(theme: @document_theme, width: @width, height: @height)
      @id = result["id"]
      @maximum_idle_duration = result["maximumIdleDuration"]
      @current_slide = result["currentSlide"]
      @slide_numbers_showing = result["slideNumbersShowing"]
      @auto_loop = result["autoLoop"]
      @auto_play = result["autoPlay"]
      @auto_restart = result["autoRestart"]
      @maximum_idle_duration = result["maximumIdleDuration"]
      @name = result["name"]
    end

    def master_slides
      results = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{id}")
        var masterSlides = doc.masterSlides()
        var results = []
        for(var i=0; i<masterSlides.length; i++) {
          results.push({ name: masterSlides[i].name()})
        }
        JSON.stringify(results);
      APPLE

      return [] unless results
      results.map do |result|
        MasterSlide.new(result["name"])
      end
    end

    def slides
      results = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{id}")
        var slides = doc.slides()
        var results = []
        for(var i=0; i<slides.length; i++) {
          var slide = slides[i]
          results.push({
            base_slide: slide.baseSlide().name(),
            body_showing: slide.bodyShowing(),
            skipped: slide.skipped(),
            slide_number: slide.slideNumber(),
            title_showing: slide.titleShowing(),
            body: slide.defaultBodyItem.objectText(),
            title: slide.defaultTitleItem.objectText(),
            presenter_notes: slide.presenterNotes(),
            transition_properties: slide.transitionProperties()
          })
        }
        JSON.stringify(results);
      APPLE

      @slides = results.map do |result|
        Slide.new(
          document: self,
          base_slide: MasterSlide.new(result["base_slide"]),
          body_showing: result["body_showing"],
          skipped: result["skipped"],
          slide_number: result["slide_number"],
          title_showing: result["title_showing"],
          body: result["body"],
          title: result["title"],
          presenter_notes: result["presenter_notes"],
          transition_properties: result["transition_properties"],
        )
      end
    end

    # arguments is not implemented
    # It will support title, body, ... or so on.
    def append_slide(master_slide_name, arguments = {})
      raise ArgumentError.new "nil master_slide_name is given" unless master_slide_name

      result = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{self.id}")
        var masterSlide = doc.masterSlides.whose({name: "#{master_slide_name}"}).first
        var slide = Keynote.Slide({ baseSlide: masterSlide })
        doc.slides.push(slide)
        slide = doc.slides()[doc.slides().length - 1]
        slide.defaultTitleItem.objectText = "#{arguments[:title]}"
        slide.defaultBodyItem.objectText = "#{arguments[:body]}"

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

      slide = Slide.new(
        base_slide: MasterSlide.new(master_slide_name),
        body_showing: result["body_showing"],
        skipped: result["skipped"],
        slide_number: result["slide_number"],
        title_showing: result["title_showing"],
        body: result["body"],
        title: result["title"],
        presenter_notes: result["presenter_notes"],
        transition_properties: result["transition_properties"],
      )
      @slides << slide
    end

    def save
      return false unless @id
      return false unless @file_path
      eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var doc = Keynote.documents.byId("#{@id}")
        var path = Path("#{@file_path}")
        doc.save({ in: path })
      APPLE
      true
    rescue => e
      false
    end

    class DocumentInvalid < RuntimeError; end

    def save!
      raise DocumentInvalid unless save
    end

    def export
      # TBD
    end

    def self.create(arguments = {})
      theme = arguments[:theme] || Theme.default
      width = arguments[:width]
      height = arguments[:height]

      eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var theme = Keynote.themes.whose({ id: "#{theme.id}" }).first
        Keynote.documents.push(Keynote.Document({ documentTheme: theme, width: #{width}, height: #{height} }));
        var doc = Keynote.documents()[Keynote.documents().length - 1];
        JSON.stringify({
          id: doc.id(),
          height: doc.height(),
          autoRestart: doc.autoRestart(),
          maximumIdleDuration: doc.maximumIdleDuration(),
          width: doc.width(),
          slideNumbersShowing: doc.slideNumbersShowing(),
          autoPlay: doc.autoPlay(),
          autoLoop: doc.autoLoop(),
          name: doc.name()
        });
      APPLE
    end
  end
end
