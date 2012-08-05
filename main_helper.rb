require './hero.rb'

DOTA2_DIRECTORY = "dota2"
DOTA2_STATS_FILE = "stats.html"

def check_directories
	if ! File.directory? "heroes"
		Dir.mkdir "heroes"
	end

	if ! File.directory? DOTA2_DIRECTORY
		Dir.mkdir DOTA2_DIRECTORY
	end
end

def scrape_dota2_heroes
	heroes = []
	File.open(File.join(DOTA2_DIRECTORY, DOTA2_STATS_FILE)) do |stats_file|
		document = Nokogiri::HTML(stats_file)
		stats = document.css("#heroes tr")
		stats.each do |hero|
			fields = ["icon", "name", "Win %", "Matches", "Avg. kills", 
					"Avg. deaths", "Avg. assists", "Avg. lasthits", "Avg. denies", "Avg. GPM"]
			hero_stats = hero.css("td")
			unless hero_stats.empty?
				heroes << Hero.new
				hero_hash = Hash[fields.zip(hero_stats.map {|hs| hs.content})]
				heroes.last.name = hero_hash["name"]
				heroes.last.matches_played = hero_hash["Matches"]
				heroes.last.avg_kills = hero_hash["Avg. kills"]
				heroes.last.avg_assists = hero_hash["Avg. assists"]
			end
		end
	end
	heroes
end

def scrape_hon_heroes
	heroes_filenames = `ls -1 heroes`.split("\n")
	heroes_array = `grep source heroes/#{heroes_filenames[0]}`.split("source:").last.strip.chop.gsub("[", '').gsub("]",'').gsub('"', '').split(",")
	heroes_hash = Hash[heroes_filenames.zip(heroes_array)]
	heroes = []
	heroes_filenames.each do |hero_filename|
		File.open("heroes/"+hero_filename) do |hero_file|
			document = Nokogiri::HTML(hero_file)
			heroes << Hero.new
			stats = document.css("#usage_stats > p")
			stats.each do |stat|
				name, value = stat.content.split(":")
				heroes.last.add_value(name, value)
				heroes.last.file_name = hero_filename
				heroes.last.name = heroes_hash[hero_filename]
			end
		end
	end
	heroes
end

def kills_per_game(heroes)
	kills = heroes.inject(0) do |sum, hero|
		sum + hero.avg_kills
	end
	kills_per_hero = kills / heroes.count
	kills_per_game = kills_per_hero * 10
end

def games_played(heroes)
	games = heroes.inject(0) do |sum, hero|
		sum + hero.matches_played
	end
	games /= 10
end

def avg_game_time(heroes)
	time_played = heroes.inject(0) do |sum, hero|
		sum + hero.time_played
	end
	time_played_per_hero = time_played / heroes.count
	time_per_game = time_played_per_hero * 10 / games_played(heroes)
end
