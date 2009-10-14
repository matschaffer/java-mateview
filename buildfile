require 'lib/patch/buildr/eclipse'

repositories.remote << "http://www.ibiblio.org/maven2"
repositories.remote << "http://repository.codehaus.org"

def property(name)
  java.lang.System.getProperty name
end

SWT_LIB = ENV['SWT_LIB'] || case property "os.name"
when /OS X/i
  (property("os.arch").include?("64")) ? "lib/osx64/swt.jar" : "lib/osx/swt.jar"
when /linux/i
  "lib/linux/swt.jar"
else
  abort "No swt.jar currently available for your platform (#{property 'os.name'} - #{property 'os.arch'}). Please download it and build with SWT=/path/to/swt.jar."
end

desc "The core component of the redcar text editor used for parsing and resolving TextMate language specifications."
define "java-mateview" do
  project.version = "0.0.1"
  project.group = "com.redcareditor"
  
  define "api" do
    compile.with Dir["lib/org.eclipse.*.jar"] + [SWT_LIB] +
                 ["org.jruby.joni:joni:jar:1.1.3", "org.jdom:jdom:jar:1.1", "org.jruby.jcodings:jcodings:jar:1.0.1"]
    package(:jar)
    package.enhance do
      write(_("target/java-mateview-init-#{version}.rb"),
            (compile.dependencies + [package] + Dir[_("src/main/ruby/*.rb")]).map{ |d| "require '#{d}'"}.join("\n"))
    end
  end

  define "specs" do
    test.with project("api").compile.dependencies + [project("api").compile.target, project("api")._("target/resources")]
    test.using :rspec, :requires => Dir[project("api")._("src/main/ruby/*.rb")]
  end
end
