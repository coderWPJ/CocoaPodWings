#!/usr/bin/ruby

module Wing
  class Command
    class Go < Command
      def run
#        start_publish
#        path = '~/Desktop'
        puts "当前路径" + Dir.pwd
        path = File::expand_path('~/Desktop')

        Dir.chdir(path)
        puts "当前路径" + Dir.pwd

        str = %Q("cd #{path}")
        puts str
        system(str)
      end
    end
  end
end
