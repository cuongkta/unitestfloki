defmodule MyModuleFloki do
	
	def check(html,checkstring) do
		
		Floki.find(html, checkstring)
	end

	def parse(html,checkstring) do 
		Floki.parse(html,checkstring);
	end 
end