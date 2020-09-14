require 'claide'

module Wing
  class Command < CLAide::Command
      
    require 'cocoapodwings/command/publish'
    require 'cocoapodwings/command/go'
    
    self.abstract_command = true
    self.command = 'wing'
    self.version = VERSION
    
    self.description = 'PodWings, avaluable widget for CocoaPods'
    
    def self.run(argv)
      super(argv)
    end
  end
end
