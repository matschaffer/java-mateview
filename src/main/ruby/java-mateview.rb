require 'java'

$CLASSPATH << File.expand_path(File.join(File.dirname(__FILE__), *%w(.. .. bin)))
$:.push(File.expand_path(File.join(File.dirname(__FILE__), *%w(.. .. lib))))

require 'jdom'

require 'rbconfig'

swt_lib = case Config::CONFIG["host_os"]
  when /darwin/i
    if Config::CONFIG["host_cpu"] == "x86_64"
      'osx64/swt'
    else
      'osx/swt'
    end
  when /linux/i
    'linux/swt'
  when /windows/i
    'windows/swt'
end

require swt_lib
require 'org.eclipse.core.commands'
require 'org.eclipse.core.runtime_3.5.0.v20090525'
require 'org.eclipse.equinox.common'
require 'org.eclipse.jface.databinding_1.3.0.I20090525-2000'
require 'org.eclipse.jface'
require 'org.eclipse.jface.text_3.5.0'
require 'org.eclipse.osgi'
require 'org.eclipse.text_3.5.0.v20090513-2000'

require 'swt_wrapper'

unless defined?(JavaMateView)

  module JavaMateView
    import com.redcareditor.mate.MateText
    import com.redcareditor.mate.Grammar
    import com.redcareditor.mate.Bundle
    import com.redcareditor.theme.Theme
    import com.redcareditor.theme.ThemeManager
  end

  module Plist
    import com.redcareditor.plist.Dict
    import com.redcareditor.plist.PlistNode
    import com.redcareditor.plist.PlistPropertyLoader
  end

  module Onig
    import com.redcareditor.onig.Rx
    import com.redcareditor.onig.Match
  end
end
