module BusinessLayer
	class IRepository
		def initialize(speaker)
			@speaker = speaker
		end
		
		def Speaker
			@speaker
		end
		
		def Speaker=(value)
			@speaker=  value
		end
		
		def SaveSpeaker(speaker)
		end
	end
end