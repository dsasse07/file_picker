

class FilePicker
  include CliControls

  attr_reader :directory, :files

  def initialize
    @directory = ENV["FILE_DIRECTORY"]
    @files = Dir.entries(@directory).select { |f| File.file? File.join(@directory, f) }
  end

  def run
    welcome
    main_menu
  end

  private

  def welcome
    puts "
    ______ _ _     ______ _      _             
    |  ___(_) |    | ___ (_)    | |            
    | |_   _| | ___| |_/ /_  ___| | _____ _ __ 
    |  _| | | |/ _ |  __/| |/ __| |/ / _ ` '__|
    | |   | | |  __/ |   | | (__|   <  __/ |   
    |_|   |_|_||___|_|   |_|,___|_|`_|___|_|   
                                               
    "
  end

  def main_menu
    choices = ["Open Random", "Select File", "Exit"]
    selection = @@prompt.select("What would you like to do?", choices)
    case selection
    when "Open Random" 
      open_random
      main_menu
    when "Select File"
      select_file
      main_menu
    when "Exit"
      system 'clear'
      exit
    end
  end

  def open_random
    random_index = rand(0...@files.length)
    filename = @files[ random_index]
    open( filename )
  end

  def open( filename )
    path = ENV["RUN_DIRECTORY"] + filename
    system `explorer.exe "#{path}"`
  end

  def select_file
    filename = @@prompt.select("Select File", @files, filter: true)
    open( filename )
  end



  
end





# binding.pry
false
