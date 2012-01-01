
baseFolder = ARGV.first

at_exit do
  gets
end

unless baseFolder
  candidates = [
    'C:\Program Files (x86)\Steam\SteamApps\common\disciples 3',
    'C:\Program Files\Steam\SteamApps\common\disciples 3',
  ]
  candidates.each do |candidate|
    baseFolder = candidate if Dir.exists? candidate
  end
end

unless baseFolder
  puts 'Please enter the path to disciples 3'
  puts 'EG: C:\Program Files (x86)\Steam\SteamApps\common\disciples 3'
  baseFolder = gets.strip
end

unless Dir.exists? baseFolder
  puts "Folder '#{baseFolder}' does not exist"
  exit
end

sysini = File.join baseFolder, 'System', 'system.ini'

unless File.exists? sysini
  puts "System ini file not found in #{sysini}"
  exit
end

charFilesDir = File.join baseFolder, 'Resources', 'Profiles', 'desc'
charFilesGlob = File.join(charFilesDir, '*.char')

unless File.exists? charFilesDir
  puts "Character files directory not found in #{charFilesDir}"
  exit
end

puts "Patching..."

sys = File.read sysini
sys.gsub(/^float fGlobalTimeScale.*$/, "float fGlobalTimeScale = 25.00000;")
sys.gsub(/^float fTimeScale.*$/, "float fTimeScale = 25.000000;")

File.open(sysini, 'w') do |f|
  f.write(sys)
end

Dir.glob(charFilesGlob).each do |fname|
  f = File.open(fname, 'a')
  f.write("move_speed 20\n")
end

puts "Successful!"
puts "I'm @danielrheath on twitter; drop me a line if you like the patch or have any questions."
puts "Press any key to exit"
