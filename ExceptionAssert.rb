module BusinessLayerTests
	class ExceptionAssert
		def ExceptionAssert.Throws(action)
			begin
				ExceptionAssert.action()
			rescue T => ex
				return ex
			ensure
			end
			Assert.Fail("Expected exception of type {0}.", T.to_clr_type)
			return nil
		end
	end
end