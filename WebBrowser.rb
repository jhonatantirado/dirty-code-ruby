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
			if name.Contains("Firefox") then
				return BrowserName.Firefox
			end
			if name.Contains("Chrome") then
				return BrowserName.Chrome
			end
			if name.Contains("Opera") then
				return BrowserName.Opera
			end
			if name.Contains("Safari") then
				return BrowserName.Safari
			end
			if name.Contains("Dolphin") then
				return BrowserName.Dolphin
			end
			if name.Contains("Konqueror") then
				return BrowserName.Konqueror
			end
			if name.Contains("Linx") then
				return BrowserName.Linx
			end
			return BrowserName.Unknown
		end

		class BrowserName
			def initialize()
			end
		end
	end
end