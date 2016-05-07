

OptionParser.new do |parser|

  # Whenever we see -n or --name, with an 
  # argument, save the argument.
  parser.on("-n", "--name NAME", "The name of the person to greet.") do |v|
    options[:name] = v
  end
end.parse!
