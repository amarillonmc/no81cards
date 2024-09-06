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
	local _dofile=dofile
	local _loadfile=loadfile
	function dofile(str)
		if string.find(str,"%.") then
			return _dofile(str)
		else
			return _dofile(str..".lua")
		end
	end
	function loadfile(str)
		if string.find(str,"%.") then
			return _loadfile(str)
		else
			return _loadfile(str..".lua")
		end
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
	Auxiliary=Auxiliary or {}
	if not Auxiliary.GetMustMaterialGroup then
		Auxiliary.GetMustMaterialGroup=Duel.GetMustMaterial
	end
	local _SetRange=Effect.SetRange
	function Effect.SetRange(e,r,...)
		table_range=table_range or {}
		table_range[e]=r
		return _SetRange(e,r,...)
	end
	local _Clone=Effect.Clone
	function Effect.Clone(e)
		table_range=table_range or {}
		local clone_e=_Clone(e)
		table_range[clone_e]=r
		return clone_e
	end
	local _IsCanTurnSet=Card.IsCanTurnSet
	function Card.IsCanTurnSet(c)
		return (c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or ((_IsCanTurnSet(c) and not c:IsLocation(LOCATION_SZONE)))
	end
	EFFECT_FLAG_CANNOT_NEGATE=EFFECT_FLAG_CANNOT_NEGATE or 0x200
	function Group.ForEach(group,func,...)
		if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
			local d_group=group:Clone()
			for tc in aux.Next(d_group) do
				func(tc,...)
			end
		end
	end
	function Auxiliary.AddPlaceToPZoneIfDestroyEffect(c)
		--pendulum
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(13331639,3))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
							return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
						end)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
							if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
						end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
							if c:IsRelateToEffect(e) then
								Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
							end
						end)
		c:RegisterEffect(e1)
	end
	--require("script/procedure.lua")
end