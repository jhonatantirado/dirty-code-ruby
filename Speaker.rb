module BusinessLayer
	class Speaker
		def initialize(firstName, lastName, email, experience, hasBlog, blogUrl, browser, certifications, employer, registrationFee, sessions)
			@requiredCertifications = 3
			@requiredYearsOfExperience = 10
			@minRequiredBrowserVersion = 9
			@oldTechnologies = ["Cobol", "Punch Cards", "Commodore", "VBScript"]
			@domains = ["aol.com", "hotmail.com", "prodigy.com", "CompuServe.com"]
			@employers = ["Microsoft", "Google", "Fog Creek Software", "37Signals"]
			
			@firstName = firstName
			@lastName = lastName
			@email = email
			@experience = experience
			@hasBlog = hasBlog
			@blogUrl = blogUrl
			@browser = browser
			@certifications = certifications
			@employer = employer
			@registrationFee = registrationFee
			@sessions = sessions
		end

		def FirstName
			@firstName
		end

		def FirstName=(value)
			@firstName = value
		end

		def LastName
			@lastName
		end

		def LastName=(value)
			@lastName = value
		end

		def Email
			@email
		end

		def Email=(value)
			@email = value
		end

		def Experience
			@experience
		end

		def Experience=(value)
			@experience = value
		end

		def HasBlog
			@hasBlog
		end

		def HasBlog=(value)
			@hasBlog = value
		end

		def BlogURL
			@blogUrl
		end

		def BlogURL=(value)
			@blogUrl = value
		end

		def Browser
			@browser
		end

		def Browser=(value)
			@browser = value
		end

		def Certifications
			@certifications
		end

		def Certifications=(value)
			@certifications = value
		end

		def Employer
			@employer
		end

		def Employer=(value)
			@employer = value
		end

		def RegistrationFee
			@registrationFee
		end

		def RegistrationFee=(value)
			@registrationFee = value
		end

		def Sessions
			@sessions
		end

		def Sessions=(value)
			@sessions = value
		end
		
		def Register(repository)
			if System::String.IsNullOrWhiteSpace(self.FirstName) then
				raise ArgumentNullException.new("First Name is required")
			end
			if System::String.IsNullOrWhiteSpace(self.LastName) then
				raise ArgumentNullException.new("Last name is required.")
			end
			if System::String.IsNullOrWhiteSpace(self.Email) then
				raise ArgumentNullException.new("Email is required.")
			end
			if self.Sessions.Count() == 0 then
				raise ArgumentException.new("Can't register speaker with no sessions to present.")
			end
			speakerId = nil
			isGood = false
			isApproved = false
			isGood = self.meetsMinimunRequirements()
			if not isGood then
				raise SpeakerDoesntMeetRequirementsException.new("Speaker doesn't meet our abitrary and capricious standards.")
			end
			isApproved = self.hasSessionApproved()
				
			if not isApproved then
				raise NoSessionsApprovedException.new("No sessions approved.")
			end
			
			self.calculateRegistrationFee()
			begin
				speakerId = repository.SaveSpeaker(self)
			rescue Exception => e
				raise e
			ensure
			end
			return speakerId
		end
		
		def hasSessionApproved()
			result = true
			enumerator = Sessions.GetEnumerator()
			while enumerator.MoveNext()
				session = enumerator.Current
				enumerator = oldTechnologies.GetEnumerator()
				while enumerator.MoveNext()
					technology = enumerator.Current
					if session.Title.Contains(technology) or session.Description.Contains(technology) then
						session.Approved = false
						result = false
						break
					else
						session.Approved = true
					end
				end
			end
			return result
		end
		
		def meetsMinimunRequirements()
			splitted = self.Email.Split('@')
			emailDomain = splitted[splitted.Length - 1]
			result = ((self.Experience > @requiredYearsOfExperience or self.HasBlog or self.Certifications.Count() > @requiredCertifications or @employers.Contains(self.Employer) or (not @domains.Contains(emailDomain) and self.Browser.Name != WebBrowser.BrowserName.InternetExplorer and self.Browser.MajorVersion >= @minRequiredBrowserVersion)))
			return result
		end
		
		def calculateRegistrationFee()
			if self.Experience <= 1 then
				self.RegistrationFee = 500
			elsif self.Experience >= 2 and self.Experience <= 3 then
				self.RegistrationFee = 250
			elsif self.Experience >= 4 and self.Experience <= 5 then
				self.RegistrationFee = 100
			elsif self.Experience >= 6 and self.Experience <= 9 then
				self.RegistrationFee = 50
			else
				self.RegistrationFee = 0
			end
		end
	end	
		
	class SpeakerDoesntMeetRequirementsException < Exception
		def initialize(format, args)
		end
	end
	
	class NoSessionsApprovedException < Exception
		def initialize(message)
		end
	end
end