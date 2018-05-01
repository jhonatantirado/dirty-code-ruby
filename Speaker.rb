module BusinessLayer
	class Speaker
		def initialize(firstName, lastName, email, experience, hasBlog, blogUrl, browser, certifications, employer, registrationFee, sessions)		
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
		
			#lets init some vars
			speakerId = nil
			good = false
			appr = false
			
			#@nt = ["MVC4", "Node.js", "CouchDB", "KendoUI", "Dapper", "Angular"]
			@ot = ["Cobol", "Punch Cards", "Commodore", "VBScript"]
			
			#DEFECT #5274 DA 12/10/2012
			#We weren't filtering out the prodigy domain so I added it.
			@domains = ["aol.com", "hotmail.com", "prodigy.com", "CompuServe.com"]
			
			if not System::String.IsNullOrWhiteSpace(FirstName) then
				if not System::String.IsNullOrWhiteSpace(LastName) then
					if not System::String.IsNullOrWhiteSpace(Email) then
						#put list of employers in array
						emps = ["Microsoft", "Google", "Fog Creek Software", "37Signals"]
						#DFCT #838 Jimmy 
						#We're now requiring 3 certifications so I changed the hard coded number. Boy, programming is hard.
						good = ((Exp > 10 or HasBlog or Certifications.Count() > 3 or emps.Contains(Employer)))
						if not good then
							#need to get just the domain from the email
							emailDomain = Email.Split('@').Last()
							if not domains.Contains(emailDomain) and (not (Browser.Name == WebBrowser.BrowserName.InternetExplorer and Browser.MajorVersion < 9)) then
								good = true
							end
						end
						
						if good then
							#DEFECT #5013 CO 1/12/2012
							#We weren't requiring at least one session
							if Sessions.Count() != 0 then
								enumerator = Sessions.GetEnumerator()
								while enumerator.MoveNext()
									session = enumerator.Current
									#foreach (var tech in nt)
									#{
									#    if (session.Title.Contains(tech))
									#    {
									#        session.Approved = true;
									#        break;
									#    }
									#}
									enumerator = ot.GetEnumerator()
									while enumerator.MoveNext()
										tech = enumerator.Current
										if session.Title.Contains(tech) or session.Description.Contains(tech) then
											session.Approved = false
											break
										else
											session.Approved = true
											appr = true
										end
									end
								end
							else
								raise ArgumentException.new("Can't register speaker with no sessions to present.")
							end
							
							if appr then
								#Now, save the speaker and sessions to the db.
								begin
									speakerId = repository.SaveSpeaker(self)
								rescue Exception => e
								ensure
								end
							else
								raise NoSessionsApprovedException.new("No sessions approved.")
							end
						else
							raise SpeakerDoesntMeetRequirementsException.new("Speaker doesn't meet our abitrary and capricious standards.")
						end
					else
						raise ArgumentNullException.new("Email is required.")
					end
				else
					raise ArgumentNullException.new("Last name is required.")
				end
			else
				raise ArgumentNullException.new("First Name is required")
			end
			
			#if we got this far, the speaker is registered.
			return speakerId
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