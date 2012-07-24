class Hero
	attr_accessor :name, :matches_played, :time_played, :avg_kills, :avg_deaths, :avg_assists, :wins, :losses, :avg_creep_kills, :avg_creep_denies, :avg_exp_per_min, :avg_gold_per_min, :file_name

	def add_value(name, value)
		case name
		when "Matches Played"
			@matches_played = value_to_i(value)
		when "Wins"
			@wins = value_to_i(value)
		when "Losses"
			@losses = value_to_i(value)
		when "Time Played"
			#in seconds
			@time_played = value_to_minutes(value)
		when "Avg K/D/A"
			@avg_kills, @avg_deaths, @avg_assists = value_to_kda(value)
		when "Avg Exp. per Min"
			@avg_exp_per_min = value_to_i(value)
		when "Avg Gold per Min"
			@avg_gold_per_min = value_to_i(value)
		when "Avg Creep Kills"
			@avg_creep_kills = value.to_f
		when "Avg Creep Denies"
			@avg_creep_denies = value.to_f
		end
	end

	private
	def value_to_i(value)
		value.strip.gsub(",", '').to_i
	end
	
	def value_to_minutes(value)
		hours, minutes = value.strip.gsub("m", '').split("h").map do |x| x.to_i end
		hours * 60 + minutes
	end

	def value_to_kda(value)
		value.split("/").map do |x|
			x.strip.to_f
		end
	end
end
