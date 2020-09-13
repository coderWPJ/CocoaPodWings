#!/usr/bin/ruby

def start_publish
  root_path = Dir::pwd
  folder_name = root_path.split('/')[-1]
  spec_file_name = folder_name + '.podspec'
  spec_file_path = File.join(root_path, spec_file_name)
  
  unless File.exist?(spec_file_path)
    raise "#{spec_file_name} 文件不存在！"
  end
  proj_name = folder_name
  
  old_version = get_version_str(spec_file_path)
  new_version = genrate_new_spec_content(spec_file_path)
  
  puts "版本号即将从  #{old_version} >>>>>> 更新到 >>>>>> #{new_version}"
  puts "请输入提交 #{new_version} 版本的日志信息: "
  logInfo = STDIN.gets.chomp()
  
  puts "日志：" + logInfo
  sh "git pull origin master"
  sh "git add --all"
  sh %Q(git commit -am "#{logInfo}     -- Shell commit")
  sh %Q(git tag "#{new_version}")
  sh %Q(git push origin master --tags)
  
#  `%Q(git add --all)`
#  `%Q(git commit -am "#{logInfo}     -- Shell commit")`
#  `%Q(git tag "#{new_version}")`
#  `%Q(git push origin master --tags)`
  
end

def get_version_str(spec_file_path)
  lines = IO.readlines(spec_file_path)
  version = '0'
  lines.each do |line|
    if (line =~ /.*.version\s*=/)
        version = line.split('"')[1]
    end
  end
  return version
end

# 获取新的版本号，并且更新spec文件
def genrate_new_spec_content(spec_file_path)
    lines = IO.readlines(spec_file_path)
    version_line = -1
    new_version = '0'
    lines.each_with_index do |line, idx|
      if (line =~ /.*.version\s*=/)
        version_line = idx
        ver_num_arr = line.split('.')
        last_num = ver_num_arr.pop
        new_num = last_num.to_i+1
        new_version_arr = ver_num_arr << "#{new_num}"
        new_version = new_version_arr.join('.')
      end
    end
    unless version_line >= 0
      raise "#{spec_file_name} 版本号异常"
    end
    new_version << %Q(")
    lines[version_line] = new_version
    File.open(spec_file_path, 'w') {|file|
        file.puts lines
    }
    return new_version.split('"')[1]
end

module Wing
  class Command
    class Publish < Command
      def run
        start_publish
      end
    end
  end
end
