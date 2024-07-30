function Auxiliary.PreloadUds()
	PreloadUds_Done=true
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
	local release_set={"CheckReleaseGroup","SelectReleaseGroup"}
	local release_set2={"CheckReleaseGroupEx","SelectReleaseGroupEx"}
	for i,fname in pairs(release_set) do
		local temp_f=Duel[fname]
		Duel[fname]=function(...)
						local params={...}
						local old_minc=params[3]
						local typ=type(old_minc)
						if #params>2 and typ~="number" then
							if params[1]==REASON_COST then
								return temp_f(table.unpack(params,2,#params))
							else
								local fname2=release_set2[i]
								local tab={table.unpack(params,2,#params)}
								table.insert(tab,i+3,params[1])
								table.insert(tab,i+4,false)
								return Duel[fname2](table.unpack(tab))
							end
						end
						return temp_f(...)
					end
	end
	for i,fname in pairs(release_set2) do
		local temp_f=Duel[fname]
		Duel[fname]=function(...)
						local params={...}
						local old_minc=params[3]
						local typ=type(old_minc)
						if #params>2 and typ~="number" then
							local tab={table.unpack(params,2,#params)}
							table.insert(tab,i+3,params[1])
							table.insert(tab,i+4,true)
							return temp_f(table.unpack(tab))
						elseif #params>=i+3 and type(params[i+3])~="number" then
							local tab=params
							table.insert(tab,i+3,REASON_COST)
							table.insert(tab,i+4,true)
							return temp_f(table.unpack(tab))
						end
						return temp_f(...)
					end
	end
	if not Auxiliary.GetMustMaterialGroup then
		Auxiliary.GetMustMaterialGroup=Duel.GetMustMaterial
	end
	local _SetRange=Effect.SetRange
	function Effect.SetRange(e,r,...)
		table_range=table_range or {}
		table_range[e]=r
		return _SetRange(e,r,...)
	end
	--[[local _IsCanTurnSet=Card.IsCanTurnSet
	function Card.IsCanTurnSet(c)
		return (c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or ((_IsCanTurnSet(c) and not c:IsLocation(LOCATION_SZONE)))
	end--]]
	EFFECT_FLAG_CANNOT_NEGATE=EFFECT_FLAG_CANNOT_NEGATE or 0x200
	--require("script/procedure.lua")
	Duel.ResetTimeLimit(0,360)
	Duel.ResetTimeLimit(1,360)
end