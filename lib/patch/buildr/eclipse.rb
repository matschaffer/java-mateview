# Monkey patch to get around buildr eclipse issue it be fixed in buildr 1.3.5
# https://issues.apache.org/jira/browse/BUILDR-315

require 'pathname'

class Buildr::Eclipse::ClasspathEntryWriter
  alias :_src :src
  def src arg
    if arg.respond_to?(:partition)
      files, sources = arg.partition { |dep| dep.is_a?(String) && Pathname.new(dep).file? }
      lib files
      _src sources
    else
      _src arg
    end
  end
end