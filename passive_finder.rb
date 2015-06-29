topics = Dir.glob('./**/*.html*')
output_file = './passives.txt'

reg = /(are|were|been|have|has|have)( \w+)? \w+e[dn]/m

passives = []
passive_lines = []

File.open(output_file, "w") { |file| file << "Passives:" }

def render_match_data match_data, file

    file << "\n\tTopic path: #{match_data[:topic]}; line number: #{match_data[:line_number]}"
    file << "\n\t\t#{match_data[:line]} "
    
end

topics.each do |topic_path|

  topic_lines = File.open(topic_path, 'r')

  
  topic_lines.each_with_index do |line, i|
    matches = line.scan reg

    matches.each do |m|

      match_data = {
        topic: topic_path,
        line_number: i+1,
        line: line,
        match: m
      }
    
      passives << match_data
    
      File.open(output_file, "a") do |file|
        render_match_data match_data, file
      end
    end
  
    passive_lines << line if matches.length > 0
  
    
  end
  if ARGV[0] && ARGV[0].to_i.to_s == ARGV[0]
    break if passives.length > ARGV[0].to_i
  end

end

puts "passives: #{passives.length}"
