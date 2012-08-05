#!/usr/bin/ruby1.9.1
require 'nokogiri'
require 'pp'
require './main_helper.rb'
require 'pry'


check_directories
# process command line options
update = true
puts ARGV[0]
case  ARGV[0]
when "--no-update"
	puts "... Data will not be updated!"
	update = false
when "--help", "-h"
	puts "Usage: #{$0} [--no-update]"
	exit 0
end

# get all heroes webpages (assumess there is no hero with a number greater than 300.
if update
	`curl http://www.heroesofnewerth.com/heroes.php?hero_id=[001-300] -o "heroes/hero_#1.html"`
	`curl http://stats.dota2.be/herostats/recent -o "#{DOTA2_DIRECTORY}/#{DOTA2_STATS_FILE}"`
end

heroes = scrape_hon_heroes
dota_heroes =scrape_dota2_heroes

binding.pry
puts "Heroes of Newerth stats of the last 7 days:"
puts "Games played: #{games_played(heroes)}"
puts "Overall Kills per game: #{kills_per_game(heroes)}"
puts "Average Game Time: #{avg_game_time(heroes)} minutes"
puts "-"*10
binding.pry
puts "DotA2 stats of the last 3 days:"
puts "Games played: #{games_played(dota_heroes)}"
puts "Overall Kills per game: #{kills_per_game(dota_heroes)}"
puts "No average game time currently available."
