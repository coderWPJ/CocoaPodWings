#!/usr/bin/ruby

require 'fileutils'

$specs_repo_path = File::expand_path('~/Desktop/ZYWidgets/ZYPodSpecs')

def start_publish
  root_path = Dir::pwd
  folder_name = root_path.split('/')[-1]
  spec_file_name = folder_name + '.podspec'
  spec_file_path = File.join(root_path, spec_file_name)
  
  unless File.exist?(spec_file_path)
    raise "#{spec_file_name} 文件不存在！"
  end
  
  old_version = get_version_str(spec_file_path)
  new_version = get_target_version_str(spec_file_path)
  puts "版本号即将从  #{old_version} >>>>>> 更新到 >>>>>> #{new_version}"
  puts "请输入提交 #{new_version} 版本的日志信息: "
  log_info = STDIN.gets.chomp()
  
  # 更新 podspec 文件版本号
  genrate_new_spec_content(spec_file_path)
  
  # 提交pod仓库代码
  handler_git_pod_repo(new_version, log_info)
  puts "🎉🎉🎉🎉🎉🎉    #{folder_name} 仓库发布完毕"
  
  # 检测本地是否有specs仓库
  repo_exist = File.exist?($specs_repo_path)
  is_directory = File.directory?($specs_repo_path)
  unless repo_exist && is_directory
    return
  end
  puts ">>>>>>>>>>>>    准备更新spec仓库"
  
  # copy podspec文件到目标specs仓库中
  copy_spec_file_to_repo(folder_name, new_version, spec_file_path)
  
  puts ">>>>>>>>>>>>    spec copy结束， 开始提交spec仓库"
  handler_git_specs_repo(folder_name, new_version)

  puts "🎉🎉🎉🎉🎉🎉    #{folder_name}版本已更新至 #{new_version}"
end

def handler_git_specs_repo(proj_name, new_version)
  Dir.chdir($specs_repo_path)
  system(%Q(git rm -r --cached "#{proj_name}"))
  system("git add --all")
  system(%Q(git commit -am "#{proj_name}: #{new_version}  -- Wing commit"))
  system("git pull origin master")
  system("git push origin master --tags")
end
  
def copy_spec_file_to_repo(folder_name, new_version, spec_file_path)
  repo_dir_path = File.join($specs_repo_path, folder_name)
  FileUtils.makedirs(repo_dir_path) unless File.exists?(repo_dir_path)
  version_dir_path = File.join(repo_dir_path, new_version)
  FileUtils.makedirs(version_dir_path) unless File.exists?(version_dir_path)
  target_spec_file_path = File.join(version_dir_path, File.split(spec_file_path)[-1])
  FileUtils.cp(spec_file_path, target_spec_file_path)
  return true
end

def handler_git_pod_repo(new_version, log_info)
  system("git pull origin master")
  system("git add --all")
  system(%Q(git commit -am "#{log_info}     -- Wing commit"))
  system(%Q(git tag "#{new_version}"))
  system(%Q(git push origin master --tags))
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

def get_target_version_str(spec_file_path)
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
    raise "#{spec_file_path} 版本号获取出现异常"
  end
  return new_version.split('"')[1]
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
      raise "#{spec_file_path} 版本号异常"
    end
    new_version << %Q(")
    lines[version_line] = new_version
    File.open(spec_file_path, 'w') {|file|
        file.puts lines
    }
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
