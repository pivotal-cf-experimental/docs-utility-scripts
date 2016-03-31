# this utility takes a filename and renumbers all of the steps that are formatted the way we format them in docs, i.e. a link immediately followed by the word Step with a number. it beats doing it by hand.

target_file = ARGV[0]
text = File.read(target_file)
puts text

step_regex = /## <a id=[",'].*?a>\s*?Step \d+/

steps = text.scan step_regex

puts "steps before:"

steps_before = steps.clone.map { |step| step.clone }
p steps_before
steps_before.each { |step| p step }

steps_after = steps.clone.each_with_index.map do |step,i|
	step.sub!(/Step \d+/, "Step #{(i+1).to_s}")
end

puts "steps after:"
p steps_after
steps_after.each { |step| p step }
counter = 0
steps_before.each_with_index do |sb,i|
	puts 'searching text for:'
	puts sb
	match = text.scan sb
	raise 'nothing found' if match.length == 0
	text.sub! sb, steps_after[i]
	counter += 1
end

puts text
puts "Counter is #{counter}"
File.open(target_file, "w") { |file| file << text }
