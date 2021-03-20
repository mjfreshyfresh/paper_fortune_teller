require 'json'
require "prawn"
require 'prawn/measurement_extensions'

###
## Methods. These are called when needed but do not run unless called.
###
def read_file(file_name)
  file = File.open(file_name, "r")
  data = file.read
  file.close
  return data
end

def choices_are_balanced(fortune)
  number_of_evens = 0
  number_of_odds = 0  
  choices = fortune["choices"]  
  choices.each do | choice |
    if choice.length.even?
      number_of_evens = number_of_evens + 1
    else
      number_of_odds = number_of_odds + 1    
    end
  end
  return (number_of_evens == number_of_odds)
end

def describe_choices(fortune)
  choices = fortune["choices"]  
  choices.each do | choice |
    puts "Even: #{choice.length.even?} Length: #{choice.length} Choice: #{choice}"
  end
end
  
def fortunes_are_correct_length(fortune, max_length)
  fortunes = fortune["fortunes"]  
  fortunes.each do | fortune |
    if fortune.length > max_length
      return false
    end
  end
  return true
end

def describe_fortunes(fortune, max_length)
  fortunes = fortune["fortunes"]
  fortunes.each do | fortune |
    if fortune.length > max_length
      puts "Length:#{fortune.length} Fortune: #{fortune}"
    end
  end  
end

def create_pdf(fortune)
  Prawn::Document.generate("your_fortune.pdf") do
    text "Project: #{fortune["name"]}"
    move_down 5.mm    

    choices = fortune["choices"]  
    choices.each do | choice |
      text choice
      move_down 5.mm          
    end
    
    # Todo: Make the fortunes small/compact so they fit.
    fortunes = fortune["fortunes"]  
    fortunes.each do | fortune |
      text fortune
      move_down 5.mm          
    end
  end  
end

###
## Input file
###

# See fortune.json for data, you "create" the "Fortune Teller" by editing the file.
# Must include:
#  4 "Choices", balanced even/odds to provide equal odds
#  8 "Fortunes", should be longer than 5 letters and shorter than 45 charaters

###
## Run the App. This is where the action happens. When file is run the section below executes:
###
puts "--------"

json = read_file('./fortune.json')
fortune = JSON.parse(json)

puts "TESTING: #{fortune["name"]}"
puts "Contains #{fortune["choices"].length} Choices and #{fortune["fortunes"].length} Fortunes"

puts "---"
if choices_are_balanced(fortune)
  puts "OK. Your choices are well balanced in word length."
else
  puts "ERROR. Choices are not balanced even/odds which means you don't have equal chance of landing on the various Fortunes."
  describe_choices(fortune)
end

max_length = 55
puts "---"    
if fortunes_are_correct_length(fortune, max_length)
  puts "OK. Your fortunes are short enough to fit a small space."
else
  puts "ERROR. Fortunes need to be short enough to fit on the paper, something less than #{max_length} chars is suggested."
  describe_fortunes(fortune, max_length)
end


create_pdf(fortune)
  
puts "--------\n"


