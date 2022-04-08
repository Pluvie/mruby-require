##
# `require` functionality for `mruby`.
#
# Main usage: `require "filename"` or `require "filename.rb"`. The file will be searched starting from the working
# directory, which is the one where you launched the executable from.
#
# You can also require files relatively to the one currently in execution by prepending a "./". Example usage:
# `require "./dir/filename"`. Similarly, you can search in the parent directory by prepending "../".
#
# If the file is not found, this method will raise a `RuntimeError`, giving information about the absolute path
# of the file.
#
# @param file [String] the file to require.
# @return [String] the absolute path of the required file, if found.
def require file
  if file.start_with? "./"
    if $__dir.nil?
      file = file[2..]
    else
      file = "#{$__dir}/#{file[2..]}"
    end
  elsif file.start_with? "../"
    unless $__dir.nil?
      parent_dir = File.expand_path "#{$__dir}/../"
      file = "#{parent_dir}/#{file[3..]}"
      puts "parent dir: #{parent_dir}, #{file}"
    end
  end

  file = "#{file}.rb" unless file.end_with? ".rb"
  path = File.expand_path file

  raise "no such file or directory: #{path}" unless File.exist? path
  source = File.read path

  begin
    $__file = file
    $__dir = File.dirname file
    eval source
    $__file = file
    $__dir = File.dirname file
  end

  path
end
