#!/usr/bin/ruby1.9.1
require 'nokogiri'
require 'pry'
require 'pp'
require './hero.rb'

heroes_array = ["Armadon","Behemoth","Chronos","Defiler","Devourer","Blacksmith","Slither","Electrician","Nymphora","Glacius","Hammerstorm","Night Hound","Swiftblade","Blood Hunter","Kraken","Thunderbringer","Moon Queen","Pollywog Priest","Pebbles","Soulstealer","Keeper of the Forest","The Dark Lady","Demented Shaman","Voodoo Jester","War Beast","Wildsoul","Zephyr","Pharaoh","Tempest","Ophelia","Moraxus","Magebane","Legionnaire","Predator","Accursed","Nomad","The Madman","Scout","Pyromancer","Puppet Master","Pestilence","Maliken","Arachna","Hellbringer","Torturer","Jeraziah","Andromeda","Valkyrie","Wretched Hag","Succubus","Magmus","Plague Rider","Soul Reaper","Pandamonium","Vindicator","Corrupted Disciple","Sand Wraith","Rampage","Witch Slayer","Forsaken Archer","Engineer","Deadwood","The Chipper","Bubbles","Fayde","Balphagore","Gauntlet","Tundra","The Gladiator","Doctor Repulsor","Tremble","Flint Beastwood","Bombardier","Myrmidon","Dampeer","Empath","Aluna","Silhouette","Flux","Martyr","Amun-Ra","Parasite","Emerald Warden","Revenant","Monkey King","Drunken Master","Master Of Arms","Rhapsody","Geomancer","Midas","Cthulhuphant","Monarch","Gemini","Lord Salforis","Shadowblade","Kinesis","Artesia","Gravekeeper","Berzerker","Draconis","Blitz","Ellonia","Gunblade","Artillery","Riftwalker","Bramble","Ravenor","Prophet"] 
# get all heroes webpages (assumess there is no hero with a number greater than 300.
#`curl http://www.heroesofnewerth.com/heroes.php?hero_id=[001-300] -o "heroes/hero_#1.html"`
heroes_filenames = `ls -1 heroes`.split("\n")
heroes_zipped = heroes_filenames.zip heroes_array
heroes_hash = {}
heroes_zipped.each do |h|
	heroes_hash[h.first] = h.last
end
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

puts "Games played: #{games_played(heroes)}"
puts "Overall Kills per game: #{kills_per_game(heroes)}"
puts "Average Game Time: #{avg_game_time(heroes)}"
