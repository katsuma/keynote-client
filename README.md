# keynote-client

`keynote-client` will provide a high level API (like ActiveRecord style) to control your Keynote.

Currently this project is in alpha stage. It supports these features.

- Creating a new document with specified theme
- Appending a new slide with specified master slide
- Saving a document

## Install

Add this line to your application's Gemfile:

```sh
gem 'keynote-client'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install keynote-client
```


## Usage

```ruby
require 'keynote-client'
inlude Keynote

themes = Theme.find_by(:all)
# => [#<Keynote::Theme:0x007fd9ec821748 @id="Application/Black/Standard", @name="ブラック">,
# #<Keynote::Theme:0x007fd9ec821518 @id="Application/White/Standard", @name="ホワイト">,
# #<Keynote::Theme:0x007fd9ec820fa0 @id="Application/Gradient/Standard", @name="グラデーション">,
# #<Keynote::Theme:0x007fd9ec813e40 @id="Application/Parchment/Standard", @name="羊皮紙">,
# ...
# #<Keynote::Theme:0x007fd9ec813d78 @id="User/AC506922-367E-4300-AF77-8040B9CFA2B7", @name="cookpad">]

theme = Theme.find_by(name: 'ブラック').first
# #<Keynote::Theme:0x007fd9ec821748 @id="Application/Black/Standard", @name="ブラック">,

doc = Document.create(theme: theme, file_path: '/path/to/foo.key')
# => #<Keynote::Document:0x007fbe03224228
# @auto_loop=false,
# @auto_play=false,
# @auto_restart=false,
# @current_slide=nil,
# @document_theme=#<Keynote::Theme:0x007fbe031f6e68 @id="Application/Black/Standard", @name="ブラック">,
# @height=768,
# @maximum_idle_duration=15,
# @name="名称未設定",
# @slide_numbers_showing=false,
# @slides=[],
# @width=1024>

doc.save
# => true

doc.slides
# => [#<Keynote::Slide:0x007fa17c2bcb98
#  @base_slide=#<Keynote::MasterSlide:0x007fa17c2bcbe8 @name="タイトル & サブタイトル">,
#  @body_showing=true,
#  @default_body_item=nil,
#  @default_title_item=nil,
#  @presenter_notes="",
#  @skipped=false,
#  @slide_number=1,
#  @title_showing=true,
#  @transition_properties={"transitionDelay"=>0.5, "automaticTransition"=>false, "transitionEffect"=>"no transition effect", "transitionDuration"=>1}>]

doc.append_slide("空白")
# => [#<Keynote::Slide:0x007fa17c2bcb98
#   @base_slide=#<Keynote::MasterSlide:0x007fa17c2bcbe8 @name="タイトル & サブタイトル">,
#   @body_showing=true,
#   @default_body_item=nil,
#   @default_title_item=nil,
#   @presenter_notes="",
#   @skipped=false,
#   @slide_number=1,
#   @title_showing=true,
#   @transition_properties={"transitionDelay"=>0.5, "automaticTransition"=>false, "transitionEffect"=>"no transition effect", "transitionDuration"=>1}>,
#  #<Keynote::Slide:0x007fa17a8bbc08
#   @base_slide=#<Keynote::MasterSlide:0x007fa17a8bbc58 @name="空白">,
#   @body_showing=false,
#   @default_body_item=nil,
#   @default_title_item=nil,
#   @presenter_notes="",
#   @skipped=false,
#   @slide_number=2,
#   @title_showing=false,
#   @transition_properties={"transitionDelay"=>0.5, "automaticTransition"=>false, "transitionEffect"=>"no transition effect", "transitionDuration"=>1}>]
```


## Supported OS
- OSX Mavericks


## License
`keynote-client` is released under the MIT License.


## Contributing

1. Fork it ( https://github.com/katsuma/keynote-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
