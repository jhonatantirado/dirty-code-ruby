require_relative 'Speaker'
module DataAccessLayer
	class SqlServerCompactRepository
		def SaveSpeaker(speaker)
			#TODO: Save speaker to DB for now. For demo, just assume success and return 1.
			return 1
		end
	end
end