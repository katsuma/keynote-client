# keynote-client

`keynote-client` will provide a high level API (like ActiveRecord style) to control your Keynote.

Currently this project is in alpha stage.
We support only Theme object.


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
