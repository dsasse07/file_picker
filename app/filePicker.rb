# ENV Variable Config:
# MNT_DIRECTORY = path to get from this app to /mnt in WSL
# ex: ../../../../mnt/
# FILE_DIRECTORY = Path(s) from /mnt to the files
# ex: a/videos
# RUN_DIRECTORY = #Windows path from drive to file's directory. 
# Ex: C:\\Program Files\\Some Folder\\Example.txt

# If using external drive and wsl, ensure there is a matching drive folder in /mtn/
# sudo mkdir MNT_DIRECTORY + drive_letter
#e ex: A:\\ -> ../../../../mnt/a

# Currently only supports one-level of sub folders from the Drive root

class FilePicker
  include CliControls

  attr_reader :mnt_path, :directory_path, :files_path, :run_path, :files, :select_folder

  def initialize
    @selected_folder = ""
    get_file_paths()
    if @files_paths.length > 1
      select_folder_menu()
    else
      load_files(@files_path.first)
    end
  end

  def run
    welcome()
    main_menu()
  end

  private

  def get_file_paths
    @mnt_path=ENV["MNT_DIRECTORY"] # MNT_DIRECTORY is the directory of the /mnt path in WSL of the target drive
    @directory_paths = ENV["FILE_DIRECTORY"]
    @run_path = ENV["RUN_DIRECTORY"]
    @files_paths = @directory_paths.split(",").map{|path| @mnt_path + path } 
  end

  def load_files(file_path)
    begin
      @entries =  Dir.entries(file_path)
    rescue
      system "sudo mount -t drvfs A: /mnt/a" 
      @entries =  Dir.entries(file_path)
    ensure
      @files = @entries.select{|f| File.file? File.join(file_path, f)}
    end
  end

  def select_folder_menu()
    map = @files_paths.each_with_object({}){ |path, map| map[path.split("/").last] = path}
    choices = map.keys
    @selected_folder = @@prompt.select("Select folder", choices)
    load_files(map[@selected_folder])
    main_menu()
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
    choices = ["Open Random", "Pick Five", "Select File", "Change Folder", "Exit"]
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
      when "Change Folder"
        select_folder_menu()
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
    folder_segment = @selected_folder.empty? ? "" : "\\#{@selected_folder}\\"
    system_path_for_file = @run_path + folder_segment + filename
    system `explorer.exe "#{system_path_for_file}"`
  end

end

# binding.pry
false
