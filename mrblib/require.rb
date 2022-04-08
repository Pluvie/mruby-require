def require file
  puts "carico da: #{$__file}, percorso: #{$__dir}"

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

  _set_require_relative path do
    puts "passo: #{$__file}, percorso: #{$__dir}"
    eval source
  end
end

def _set_require_relative file
  $__file = file
  $__dir = File.dirname file

  yield if block_given?

  $__file = file
  $__dir = File.dirname file
end
