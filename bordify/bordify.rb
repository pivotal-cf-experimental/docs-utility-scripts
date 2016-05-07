require 'chunky_png'
require 'colorize'

def bordify(img_path, replace)
	img = ChunkyPNG::Image.from_file(img_path)
	if replace
		img.border!(1)
		img.save(img_path)
		puts "Overrode your old image #{img_path} with a new bordered image."
	else
		img_filename = File.basename(img_path)
		img_filename_without_ext = img_filename.split('.')[0] 
		new_img = img.border(1)
		new_img.save(img_filename_without_ext + '-bordered' + '.png')
		puts "Wrote new bordered file as #{img_filename_without_ext}-bordered.png."
	end
end

if ARGV[0] == "-o"
	bordify(ARGV[1], true)
elsif ARGV[0]
	bordify(ARGV[0], false)
elsif ARGV.empty?

	puts "\nBORDIFY".bold + "\nBordify adds a 1 x 1 black border to your screenshot."
	puts "USAGE:" + " bordify [-o] MY-SCREENSHOT.png".red
	puts "Add an alias to bordify in your bash profile so you can run it from the directory where your screenshot is located.".green
	puts "\nBy default, Bordify will create a new image called MY-SCREENSHOT-BORDERED.png."
	puts "Use the -o flag to overwrite the original image with the new bordered image."
end

