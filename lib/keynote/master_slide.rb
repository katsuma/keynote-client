module Keynote
  class MasterSlide
    attr_reader :name

    def default_names
      {
        title_and_sub_title: "タイトル & サブタイトル", # Title & Subtitle
        photo_horizontal: "画像（横長）", # Photo - Horizontal
        title_center: "タイトル（中央）", # Title - Center
        photo_vertical: "画像（縦長）", # Photo - Vertical
        title_top: "タイトル（上）", # Title - Top
        title_and_bullets: "タイトル & 箇条書き", # Title & Bullets
        title_bullets_and_photo: "タイトル、箇条書き、画像", # Title, Bullets & Photo
        bullets: "箇条書き", # Bullets
        quote: "引用", # Quote
        photo: "画像", # Photo
        blank: "空白", # Blank
      }
    end

    def initialize(name)
      @name = name
    end

  end
end
