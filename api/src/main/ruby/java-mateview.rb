require 'java'

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
