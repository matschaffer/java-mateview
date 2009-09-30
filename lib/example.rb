
require Dir["#{File.dirname(__FILE__)}/../api/target/java-mateview-init-*.rb"][0]
    
class MateExample < Jface::ApplicationWindow
  attr_reader :mate_text, :contents
  
  def initialize
    super(nil)
  end
  
  def createContents(parent)
    @contents = Swt::Widgets::Composite.new(parent, Swt::SWT::NONE)
    @contents.layout = Swt::Layout::FillLayout.new
    @mate_text = JavaMateView::MateText.new(@contents)
    @mate_text.set_grammar_by_name "Ruby"
    @mate_text.set_theme_by_name "Twilight"
    @mate_text.set_font "Monaco", 15
    return @contents
  end
  
  def initializeBounds
    shell.set_size(500,400)
  end
  
  def createMenuManager
    main_menu = Jface::MenuManager.new
    
    file_menu = Jface::MenuManager.new("File")
    main_menu.add file_menu
    exit_action = ExitAction.new
    exit_action.window = self
    exit_action.text = "Exit@Ctrl+Q"
    file_menu.add exit_action
    return main_menu
  end
  
  def self.run
    JavaMateView::Bundle.load_bundles("input/")
    p JavaMateView::Bundle.bundles.to_a.map {|b| b.name }
    JavaMateView::ThemeManager.load_themes("input/")
    p JavaMateView::ThemeManager.themes.to_a.map {|t| t.name }
    
    window = MateExample.new
    window.block_on_open = true
    window.addMenuBar
    window.open
    Swt::Widgets::Display.getCurrent.dispose
  end
  
  class ExitAction < Jface::Action
    attr_accessor :window
    
    def run
      window.close
    end
  end
end

MateExample.run

