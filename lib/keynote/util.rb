require 'open3'
require 'json'
require "tempfile"

module Keynote
  module Util
    def eval_script(script)
      file = Tempfile.new(['osascript', '.js'])
      file.write(script)
      file.close
      command = "osascript -l JavaScript #{file.path}"
      execute_out, process_status = *Open3.capture2(command)
      JSON.parse(execute_out.chomp)
    ensure
      file.delete
    end

  end
end
