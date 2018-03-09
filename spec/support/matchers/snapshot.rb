require 'yaml'

module Matchers
  class Snapshot
    attr_reader :meta, :index

    def initialize(meta, index)
      @meta = meta
      @index = index
    end

    def name
      "#{meta[:full_description]} #{index}"
    end

    def path
      spec = meta[:absolute_file_path]
      file = "#{File.basename(spec, '.*')}.yaml"
      relative = File.join('..', '__snapshots__', file)
      File.expand_path(relative, spec)
    end

    def read
      data[name]
    end

    def write(value)
      puts "Writing #{name}"

      data[name] = value

      File.open path, 'w' do |f|
        f.write data.to_yaml
      end

      value
    end

    private

    def data
      @data ||=
        begin
          YAML.load_file(path) || {}
        rescue Errno::ENOENT
          {}
        end
    end
  end
end
