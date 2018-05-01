require_relative 'SqlServerCompactRepository'

module BusinessLayerTests
	class SpeakerTests
		def initialize()
			@repository = SqlServerCompactRepository.new()
		end
		
		def Register_EmptyFirstName_ThrowsArgumentNullException() #Hard coding to single concrete implementation for simplicity here.
			#arrange
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.FirstName = ""
			#act
			exception = ExceptionAssert.Throws(speaker.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), ArgumentNullException.to_clr_type)
		end

		def Register_EmptyLastName_ThrowsArgumentNullException()
			#arrange
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.LastName = ""
			#act
			exception = ExceptionAssert.Throws(speaker.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), ArgumentNullException.to_clr_type)
		end

		def Register_EmptyEmail_ThrowsArgumentNullException()
			#arrange
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.Email = ""
			#act
			exception = ExceptionAssert.Throws(speaker.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), ArgumentNullException.to_clr_type)
		end
		
		def Register_WorksForPrestigiousEmployerButHasRedFlags_ReturnsSpeakerId() #Hard coding to single concrete implementation for simplicity here.
			#arrange
			speaker = self.GetSpeakerWithRedFlags()
			speaker.Employer = "Microsoft"
			#act
			speakerId = speaker.Register(SqlServerCompactRepository.new())
			#assert
			Assert.IsFalse(speakerId == nil)
		end

		def Register_HasBlogButHasRedFlags_ReturnsSpeakerId()
			#arrange
			speaker = self.GetSpeakerWithRedFlags()
			#act
			speakerId = speaker.Register(SqlServerCompactRepository.new())
			#assert
			Assert.IsFalse(speakerId == nil)
		end

		def Register_HasCertificationsButHasRedFlags_ReturnsSpeakerId()
			#arrange
			speaker = self.GetSpeakerWithRedFlags()
			speaker.Certifications = List[System::String].new("cert1", "cert2", "cert3", "cert4")
			#act
			speakerId = speaker.Register(SqlServerCompactRepository.new())
			#assert
			Assert.IsFalse(speakerId == nil)
		end

		def Register_SingleSessionThatsOnOldTech_ThrowsNoSessionsApprovedException()
			#arrange
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.Sessions = List[Session].new(Session.new("Cobol for dummies", "Intro to Cobol"))
			#act
			exception = ExceptionAssert.Throws(speaker.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), Speaker::NoSessionsApprovedException.to_clr_type)
		end
		
		def Register_NoSessionsPassed_ThrowsArgumentException() #Hard coding to single concrete implementation for simplicity here.
			#arrange
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.Sessions = List[Session].new()
			#act
			exception = ExceptionAssert.Throws(speaker.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), ArgumentException.to_clr_type)
		end

		def Register_DoesntAppearExceptionalAndUsingOldBrowser_ThrowsNoSessionsApprovedException()
			#arrange
			speakerThatDoesntAppearExceptional = self.GetSpeakerThatWouldBeApproved()
			speakerThatDoesntAppearExceptional.HasBlog = false
			speakerThatDoesntAppearExceptional.Browser = WebBrowser.new("IE", 6)
			#act
			exception = ExceptionAssert.Throws(speakerThatDoesntAppearExceptional.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), Speaker::SpeakerDoesntMeetRequirementsException.to_clr_type)
		end
		
		def Register_DoesntAppearExceptionalAndHasAncientEmail_ThrowsNoSessionsApprovedException() 
		#Hard coding to single concrete implementation for simplicity here.
			#arrange
			speakerThatDoesntAppearExceptional = self.GetSpeakerThatWouldBeApproved()
			speakerThatDoesntAppearExceptional.HasBlog = false
			speakerThatDoesntAppearExceptional.Email = "name@aol.com"
			#act
			exception = ExceptionAssert.Throws(speakerThatDoesntAppearExceptional.Register(@repository))
			#assert
			Assert.AreEqual(exception.GetType(), Speaker::SpeakerDoesntMeetRequirementsException.to_clr_type)
		end
		
		#Hard coding to single concrete implementation for simplicity here.
		def GetSpeakerThatWouldBeApproved()
			speaker = Speaker.new("First", "Last", "example@domain.com", "Example Employer", true, WebBrowser.new("test", 1), 1, Certifications.new(), "",  Session.new("test title", "test description"))
			
			return speaker
		end

		def GetSpeakerWithRedFlags()
			speaker = self.GetSpeakerThatWouldBeApproved()
			speaker.Email = "tom@aol.com"
			speaker.Browser = WebBrowser.new("IE", 6)
			return speaker
		end
	end
end