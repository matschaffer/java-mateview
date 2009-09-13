repositories.remote << "http://www.ibiblio.org/maven2"

def property(name)
  java.lang.System.getProperty name
end

SWT_LIB = ENV['SWT_LIB'] || case property "os.name"
when /OS X/i
  (property("os.arch").include?("64")) ? "lib/osx64/swt.jar" : "lib/osx/swt.jar"
when /linux/i
  "lib/linux/swt.jar"
else
  abort "No swt.jar available for your platform (#{property 'os.name'} - #{property 'os.arch'}). Please download it and build with SWT=/path/to/swt.jar."
end

desc "The core component of the redcar text editor used for parsing and resolving TextMate language specifications."
define "java-mateview" do
  project.version = "0.0.1"
  project.group = "com.redcareditor"
  manifest["Implementation-Vendor"] = "The Redcar Editor Team"
  compile.with Dir["lib/org.eclipse.*.jar", "lib/joni.jar", "lib/jdom.jar", "lib/jcodings.jar", SWT_LIB]
  
  test.using :junit unless ENV['TEST_ONLY'] == "jtestr"
  test.using :jtestr unless ENV['TEST_ONLY'] == "junit"
end
