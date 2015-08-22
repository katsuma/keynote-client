require 'unindent'
require 'keynote/util'

module Keynote
  class Theme
    extend Keynote::Util

    attr_reader :id, :name

    def initialize(id: nil, name: nil)
      @id = id
      @name = name
    end

    def self.default
      self.all.first
    end

    def self.all
      self.find_with_conditions
    end

    def self.find_by(args)
      raise ArgumentError.new('nil argument is given') unless args

      if args.is_a?(Hash) && args.has_key?(:name)
        conditions = ".whose({ name: '#{args[:name]}' })"
      else
        raise ArgumentError.new('Unsupported argument is given')
      end

      find_with_conditions(conditions)
    end

    private

    def self.find_with_conditions(conditions = '')
      results = eval_script <<-APPLE.unindent
        var themes = Application("Keynote").themes#{conditions};
        var results = [];
        for(var i = 0, len = themes.length; i < len; i++) {
          var theme = themes[i];
          results.push({ id: theme.id(), name: theme.name() });
        }
        JSON.stringify(results);
      APPLE

      return [] unless results

      results.map do |result|
        self.new(id: result["id"], name: result["name"])
      end
    end
  end
end
