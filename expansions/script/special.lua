function Auxiliary.PreloadUds()
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
			return require_list[str]
		end
		return require_list[str]
	end
	local release_set={"CheckReleaseGroup","SelectReleaseGroup","CheckReleaseGroupEx","SelectReleaseGroupEx"}
	for i,fname in pairs(release_set) do
		local temp_f=Duel[fname]
		Duel[fname]=function(...)
						local params={...}
						local old_minc=params[3]
						local typ=type(old_minc)
						if typ=="number" then return temp_f(REASON_COST,...) end
						return temp_f(...)
					end
	end
	if not Auxiliary.GetMustMaterialGroup then
		Auxiliary.GetMustMaterialGroup=Duel.GetMustMaterial
	end
	--require("script/procedure.lua")
end