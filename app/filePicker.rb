# ENV Variable Config:
# MNT_DIRECTORY = path to get from this app to /mnt in WSL
# FILE_DIRECTORY = Path from /mnt to the files
# RUN_DIRECTORY = Windows path from drive to file. Ex: C:\\Program Files\\Some Folder\\Example.txt

class FilePicker
  include CliControls

  attr_reader :mnt_path, :directory_path, :files_path, :run_path, :files

  def initialize
    get_file_paths()
    load_files()
  end

  def run
    welcome()
    main_menu()
  end

  private

  def get_file_paths
    @mnt_path=ENV["MNT_DIRECTORY"] # MNT_DIRECTORY is the directory of the /mnt path in WSL of the target drive
    @directory_path = ENV["FILE_DIRECTORY"]
    @run_path = ENV["RUN_DIRECTORY"]
    @files_path = @mnt_path+@directory_path
  end

  def load_files
    begin
      @entries =  Dir.entries(@files_path)
    rescue
      system "sudo mount -t drvfs A: /mnt/a" 
      @entries =  Dir.entries(@files_path)
    ensure
      @files = @entries.select{|f| File.file? File.join(@files_path, f)}
    end
  end

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
    choices = ["Open Random", "Pick Five", "Select File", "Exit"]
    selection = @@prompt.select("What would you like to do?", choices)
    case selection
      when "Open Random" 
        open_random()
        main_menu()
      when "Pick Five"
        5.times { open_random() }
        main_menu()
      when "Select File"
        select_file()
        main_menu()
      when "Exit"
        system 'clear'
        exit
    end
  end

  def open_random
    random_index = rand(0...@files.length)
    filename = @files[random_index]
    open_file(filename)
  end

  def select_file
    filename = @@prompt.select("Select File", @files, filter: true)
    open_file(filename)
  end

  def open_file( filename )
    system_path_for_file = @run_path + filename
    system `explorer.exe "#{system_path_for_file}"`
  end

end

# binding.pry
false
