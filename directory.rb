require 'csv'
@students = []
@filename = "students.csv"

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "sorry, #{filename} doesn't exist."
    exit
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "9"
    exit
  else
    puts "I don't know what you meant, try again"
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list"
  puts "4. Load the list"
  puts "9. Exit"
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    add_students(name)
    puts "Now we have #{@students.count} students"
    name = STDIN.gets.chomp
  end
end

def add_students(name, cohort = :september)
  @students << {name: name, cohort: cohort.to_sym}
end

def show_students
  print_header
  print_students_list
  print_footer
end

def print_header
  puts "The students of Villains Academy"
  puts "------------------"
end

def print_students_list
  @students.map do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

def get_filename
  puts "Enter the filename"
  @filename = STDIN.gets.chomp
end

def save_students
  get_filename
  CSV.open(@filename, "w", write_headers: true, headers: @students.first.keys)  do |csv|
    @students.each do |h|
      csv << h.values
    end
    puts "#{@filename} saved"
  end
end

def load_students
  get_filename
  CSV.foreach(@filename, {:headers => true, :header_converters => :symbol}) do |row|
    add_students(row[:name], row[:cohort])
  end
  puts "#{@filename} loaded"
end

try_load_students
interactive_menu