class Hero
	attr_accessor :file_name, :name
	attr_reader :matches_played, :time_played, :avg_kills, :avg_deaths, :avg_assists, :wins, :losses, :avg_creep_kills, :avg_creep_denies, :avg_exp_per_min, :avg_gold_per_min, :file_name

	def avg_creep_denies=(value)
		@avg_creep_denies = value.to_f
	end

	def avg_creep_kills=(value)
		@avg_creep_kills = value.to_f
	end

	def avg_gold_per_min=(value)
		@avg_gold_per_min = value_to_i(value)
	end

	def avg_exp_per_min=(value)
		@avg_exp_per_min = value_to_i(value)
	end

	def avg_kda=(value)
		@avg_kills, @avg_deaths, @avg_assists = value_to_kda(value)
	end

	def avg_kills=(value)
		@avg_kills = value.to_f
	end

	def avg_deaths=(value)
		@avg_deaths = value.to_f
	end

	def avg_assists=(value)
		@avg_assists = value.to_f
	end

	#takes a time in seconds
	def time_played=(value) 
		@time_played = value_to_minutes(value)
	end

	def matches_played=(value)
		@matches_played = value_to_i(value)
	end

	def wins=(value)
		@wins = value_to_i(value)
	end

	def losses=(value)
		@losses = value_to_i(value)
	end

	def add_value(name, value)
		case name
		when "Matches Played"
			self.matches_played = value
		when "Wins"
			self.wins = value
		when "Losses"
			self.losses = value
		when "Time Played"
			self.time_played = value
		when "Avg K/D/A"
			self.avg_kda = value
		when "Avg Exp. per Min"
			self.avg_exp_per_min = value
		when "Avg Gold per Min"
			self.avg_gold_per_min = value
		when "Avg Creep Kills"
			self.avg_creep_kills = value
		when "Avg Creep Denies"
			self.avg_creep_denies = value
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
