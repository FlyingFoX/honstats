#!/usr/bin/ruby1.9.1
require 'nokogiri'
require 'pp'
require './hero.rb'

if ! File.directory? "heroes"
	Dir.mkdir "heroes"
end
update = true
# get all heroes webpages (assumess there is no hero with a number greater than 300.
case  ARGV[0]
when "--no_update"
	update = false
when "--help", "-h"
	puts "Usage: #{$0} [--no_update]"
end

if update
	`curl http://www.heroesofnewerth.com/heroes.php?hero_id=[001-300] -o "heroes/hero_#1.html"`
end

heroes_filenames = `ls -1 heroes`.split("\n")
heroes_array = `grep source heroes/#{heroes_filenames[0]}`.split("source:").last.strip.chop.gsub("[", '').gsub("]",'').gsub('"', '').split(",")
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
puts "Average Game Time: #{avg_game_time(heroes)} minutes"
