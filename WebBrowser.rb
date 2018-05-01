module BusinessLayer
	class WebBrowser
		def Name
		end

		def Name=(value)
		end

		def MajorVersion
		end

		def MajorVersion=(value)
		end

		def initialize(name, majorVersion)
			self.Name = self.TranslateStringToBrowserName(name)
			self.MajorVersion = majorVersion
		end

		def TranslateStringToBrowserName(name)
			if name.Contains("IE") then
				return BrowserName.InternetExplorer
			end
			return BrowserName.Unknown
		end

		class BrowserName
			def initialize()
			end
		end
	end
end