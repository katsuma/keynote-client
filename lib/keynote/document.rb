require 'unindent'
require 'keynote/theme'
require 'keynote/slide_array'
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
      @id = arguments[:id]
      @maximum_idle_duration = arguments[:maximumIdleDuration]
      @current_slide = arguments[:currentSlide]
      @slide_numbers_showing = arguments[:slideNumbersShowing]
      @auto_loop = arguments[:autoLoop]
      @auto_play = arguments[:autoPlay]
      @auto_restart = arguments[:autoRestart]
      @maximum_idle_duration = arguments[:maximumIdleDuration]
      @name = arguments[:name]
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

      @slides = SlideArray.new(
        results.map do |result|
          Slide.new(
            MasterSlide.new(result["base_slide"]),
            document: self,
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
      )
      @slides.document = self
      @slides
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
      width = arguments[:wide] ? WIDE_WIDTH : DEFAULT_WIDTH
      height = arguments[:wide] ? WIDE_HEIGHT : DEFAULT_HEIGHT

      result = eval_script <<-APPLE.unindent
        var Keynote = Application("Keynote")
        var theme = Keynote.themes.whose({ id: "#{theme.id}" }).first
        var doc = Keynote.Document({ documentTheme: theme, width: #{width}, height: #{height} });
        Keynote.documents.push(doc);
        JSON.stringify(doc.properties());
      APPLE

      self.new(symbolize_keys(result).merge(theme: theme, width: width, height: height))
    end

    def self.find_by(args)
      raise ArgumentError.new('nil argument is given') unless args

      if args.is_a?(Hash) && args.has_key?(:id)
        conditions = ".whose({ id: '#{args[:id]}' })"
      elsif args == :all
        conditions = ''
      else
        raise ArgumentError.new('Unsupported argument is given')
      end

      results = eval_script <<-APPLE.unindent
        var documents = Application("Keynote").documents#{conditions};
        var results = [];
        for(var i = 0, len = documents.length; i < len; i++) {
          results.push(documents[i].properties());
        }
        JSON.stringify(results);
      APPLE

      return [] unless results

      results.map do |result|
        self.new(symbolize_keys(result))
      end
    end

    def self.current
      self.find_by(:all).first
    end

    private

    def self.symbolize_keys(hash)
      Hash[hash.map { |k, v| [k.to_sym, v] }]
    end
  end
end
