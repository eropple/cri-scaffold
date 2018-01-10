require "cri/scaffold/version"

require "cri"

module Cri
  def self.scaffold(path)
    Scaffold.build_command(root: File.expand_path(path))
  end

  module Scaffold
    def self.build_command(root:, name: nil, parent: nil)
      raise "#{root} does not exist." unless Dir.exist?(root)
      raise "name must be a String or nil, or parent must be nil." \
        if !parent.nil? && !name.is_a?(String)

      file = File.join(root, [name, "cli.rb"].compact.join("."))

      cmd =
        if parent.nil?
          raise "#{file} must exist." unless File.exist?(file)

          Cri::Command.new_basic_root.modify do
            program_name = File.basename($PROGRAM_NAME)
            name program_name

            instance_eval File.read(file), file
          end
        else
          parent.define_command(name.gsub("_", "-")) do |dsl|
            dsl.instance_eval File.read(file), file
          end
        end

      subdir = "#{root}/#{name || "cli"}"
      if Dir.exist?(subdir)
        Dir["#{subdir}/*.cli.rb"].each do |path|
          new_root = File.dirname(path)
          new_name = File.basename(path, ".cli.rb")

          Scaffold.build_command(root: new_root, name: new_name, parent: cmd)
        end
      end

      cmd
    end
  end
end
