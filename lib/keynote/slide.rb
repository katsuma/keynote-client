require 'unindent'
require 'keynote/util'

module Keynote
  class Slide
    extend Keynote::Util
    include Keynote::Util

    attr_accessor(
      :id,
      :base_slide,
      :body_showing,
      :skipped,
      :slide_number,
      :title_showing,
      :default_body_item,
      :default_title_item,
      :presenter_notes,
      :transition_properties,
    )

    def initialize(arguments = {})
      arguments.each do |attr, val|
        send("#{attr}=", val)
      end
    end
  end
end
