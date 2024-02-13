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
	--[[local release_set={"CheckReleaseGroup","SelectReleaseGroup","CheckReleaseGroupEx","SelectReleaseGroupEx"}
	for i,fname in pairs(release_set) do
		local temp_f=Duel[fname]
		Duel[fname]=function(...)
						local params={...}
						local old_minc=params[3]
						local typ=type(old_minc)
						if #params>2 and typ~="number" then return temp_f(table.unpack(params,2,#params)) end
						return temp_f(...)
					end
	end
	local release_set2={"CheckReleaseGroupEx","SelectReleaseGroupEx"}
	for i,fname in pairs(release_set) do
		local temp_f=Duel[fname]
		Duel[fname]=function(...)
						local params={...}
						local old_minc=params[3]
						local typ=type(old_minc)
						if #params>2 and typ~="number" then
							local tab={table.unpack(params,2,#params)}
							table.insert(tab,i+3,REASON_COST)
							table.insert(tab,i+4,true)
							return temp_f(table.unpack(tab))
						end
						return temp_f(...)
					end
	end--]]
	if not Auxiliary.GetMustMaterialGroup then
		Auxiliary.GetMustMaterialGroup=Duel.GetMustMaterial
	end
	EFFECT_FLAG_CANNOT_NEGATE=EFFECT_FLAG_CANNOT_NEGATE or 0x200
	--require("script/procedure.lua")
end