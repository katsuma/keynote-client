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
      @slides = []
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
