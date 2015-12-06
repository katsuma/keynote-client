# keynote-client

`keynote-client` will provide a high level API (like ActiveRecord style) to control your Keynote.

Currently this project is in alpha stage. It supports these features.

- Create a new document with specified theme
- Append a new slide with specified master slide
- Update slides
- Save a document

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
include Keynote

# Fetch all themes
themes = Theme.all

# Fetch theme specified name
theme = Theme.find_by(name: 'ブラック').first

# Create a new document with theme
doc = Document.create(theme: theme, file_path: '/path/to/foo.key')

# Save a document at file_path
doc.save

# Initialize a new slide
slide = Slide.new("タイトル & 箇条書き", title: 'Pen', body: ["This is a pen", "Is this a pen?"].join("\n"))

# Append slides
doc.slides << slide

# Fetch last slide
slide = doc.slides.last

# Update a slide
slide.title = "About pen"
slide.body = "Hello, pen."
```

## Supported OS
- OS X El Capitan
- OS X Mavericks


## License
`keynote-client` is released under the MIT License.


## Contributing

1. Fork it ( https://github.com/katsuma/keynote-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
