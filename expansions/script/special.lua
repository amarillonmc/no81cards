function Auxiliary.PreloadUds()
	PreloadUds_Done=true

	local tableclone=function(tab,mytab)
		local res=mytab or {}
		for i,v in pairs(tab) do res[i]=v end
		return res
	end
	local _Card=tableclone(Card)
	local _Duel=tableclone(Duel)
	local _Effect=tableclone(Effect)
	local _Group=tableclone(Group)
	
	EFFECT_FLAG_CANNOT_NEGATE=EFFECT_FLAG_CANNOT_NEGATE or 0x200
	EFFECT_FLAG_CAN_FORBIDDEN=EFFECT_FLAG_CAN_FORBIDDEN or 0x200

	table_range=table_range or {}
	effect_handler=effect_handler or {}
	effect_registered=effect_registered or {}
	require_list=require_list or {}
	
	function require(str)
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
	--(p,f,ct,exc) (p,f,min,max,exc)
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
	--(p,f,ct,r,bool,exc) (p,f,min,max,r,bool,exc)
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
	
	local _CreateEffect=Effect.CreateEffect
	function Effect.CreateEffect(c,...)
		if aux.GetValueType(c)~="Card" then assert(false,"Effect.CreateEffect没有输入正确的Card参数。") return end
		local e=_CreateEffect(c,...)
		if e and c then effect_handler[e]=c end
		return e
	end
	local _SetRange=Effect.SetRange
	function Effect.SetRange(e,r,...)
		if e and r then table_range[e]=r end
		return _SetRange(e,r,...)
	end
	local _Clone=Effect.Clone
	function Effect.Clone(e,...)
		local clone_e=_Clone(e,...)
		if e and clone_e then
			effect_handler[clone_e]=effect_handler[e]
			table_range[clone_e]=table_range[e]
		end
		return clone_e
	end
	if not Effect.GetRange then
		function Effect.GetRange(e)
			if table_range and table_range[e] then
				return table_range[e]
			end
			Debug.Message("Effect.GetRange没有及时加载该效果的Range信息。")
			return 0
		end
	end

	local _CRegisterEffect=Card.RegisterEffect
	function Card.RegisterEffect(c,e,...)
		if aux.GetValueType(c)~="Card" then assert(false,"Card.RegisterEffect没有输入正确的Card参数。") return end
		if aux.GetValueType(e)~="Effect" then assert(false,"Card.RegisterEffect没有输入正确的Effect参数。") return end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not table_range[e] then
			table_range[e]=LOCATION_HAND+LOCATION_SZONE
		elseif e:IsHasType(EFFECT_TYPE_EQUIP) and not table_range[e] then
			table_range[e]=LOCATION_SZONE
		elseif e:IsHasType(EFFECT_TYPE_FLIP) and not table_range[e] then
			table_range[e]=LOCATION_MZONE
		elseif e:IsHasType(EFFECT_TYPE_XMATERIAL) and not table_range[e] then
			table_range[e]=LOCATION_OVERLAY
		end
		local eid=_CRegisterEffect(c,e,...)
		if e and eid then effect_registered[e]=true end
		return eid
	end
	local _DRegisterEffect=Duel.RegisterEffect
	function Duel.RegisterEffect(e,p,...)
		if aux.GetValueType(e)~="Effect" then assert(false,"Duel.RegisterEffect没有输入正确的Effect参数。") return end
		_DRegisterEffect(e,p,...)
		if e then effect_registered[e]=true end
	end

	local _GetHandler=Effect.GetHandler
	function Effect.GetHandler(e,...)
		--warning!!!
		if _Effect.IsHasType(e,EFFECT_TYPE_XMATERIAL) and not effect_registered[e] then return effect_handler[e] end
		local c=_GetHandler(e,...)
		if not c then return effect_handler[e] end
		return c
	end

	local _IsCanTurnSet=Card.IsCanTurnSet
	function Card.IsCanTurnSet(c)
		return (c:IsSSetable(true) and c:IsLocation(LOCATION_SZONE)) or ((_IsCanTurnSet(c) and not c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_BATTLE_DESTROYED)))
	end
	local _IsCanChangePosition=Card.IsCanChangePosition
	function Card.IsCanChangePosition(c)
		return _IsCanChangePosition(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
	end
	
	local _IsTuner=Card.IsTuner
	function Card.IsTuner(c,...)
		local ext_params={...}
		if #ext_params==0 then return true end
		return _IsTuner(c,...)
	end
	local _IsCanBeSynchroMaterial=Card.IsCanBeSynchroMaterial
	function Card.IsCanBeSynchroMaterial(c,...)
		local ext_params={...}
		if #ext_params==0 then return _IsCanBeSynchroMaterial(c,...) end
		local sc=ext_params[1]
		local tp=sc:GetControler()
		if c:IsLocation(LOCATION_MZONE) and not c:IsControler(tp) then
			local mg=Duel.GetSynchroMaterial(tp)
			return mg:IsContains(c) and _IsCanBeSynchroMaterial(c,...)
		end
		return _IsCanBeSynchroMaterial(c,...)
	end
	
	local _SendtoDeck=Duel.SendtoDeck
	function Duel.SendtoDeck(g,top,...)
		local cg=nil
		if aux.GetValueType(g)=="Card" then
			cg=Group.FromCards(g)
		elseif aux.GetValueType(g)=="Group" then
			cg=g
		end
		if cg and top then
			local ag=cg:Filter(function(c) return c:IsLocation(LOCATION_DECK) and c:IsControler(1-top) end,nil)
			if #ag>0 then
				Duel.ConfirmCards(0,ag)
				Duel.ConfirmCards(1,ag)
			end
		end
		return _SendtoDeck(g,top,...)
	end
	local _SendtoHand=Duel.SendtoHand
	function Duel.SendtoHand(g,top,...)
		local cg=nil
		if aux.GetValueType(g)=="Card" then
			cg=Group.FromCards(g)
		elseif aux.GetValueType(g)=="Group" then
			cg=g
		end
		if cg and top then
			local ag=cg:Filter(function(c) return c:IsLocation(LOCATION_DECK) and c:IsControler(1-top) end,nil)
			if #ag>0 then
				Duel.ConfirmCards(0,ag)
				Duel.ConfirmCards(1,ag)
			end
		end
		return _SendtoHand(g,top,...)
	end
	
	--From REIKAI
	if not Group.ForEach then
		function Group.ForEach(group,func,...)
			if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
				local d_group=group:Clone()
				for tc in aux.Next(d_group) do
					func(tc,...)
				end
			end
		end
	end
	
	Auxiliary=Auxiliary or {}
	if not Auxiliary.GetMustMaterialGroup then
		Auxiliary.GetMustMaterialGroup=Duel.GetMustMaterial
	end
	if not Auxiliary.AddPlaceToPZoneIfDestroyEffect then
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
	end
	function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
		if c:IsStatus(STATUS_COPYING_EFFECT) then return end
		local val={fun1,...}
		local fun={}
		local mat={}
		for i=1,#val do
			if type(val[i])=='function' then
				fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
			elseif type(val[i])=='table' then
				fun[i]=function(c,fc,sub,mg,sg)
						for _,fcode in ipairs(val[i]) do
							if type(fcode)=='function' then
								if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then return true end
							else
								if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then return true end
							end
						end
						return false
				end
				for _,fcode in ipairs(val[i]) do
					if type(fcode)~='function' then mat[fcode]=true end
				end
			else
				fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
				mat[val[i]]=true
			end
		end
		local mt=getmetatable(c)
		if mt.material==nil then
			mt.material=mat
		end
		if mt.material_count==nil then
			mt.material_count={#fun+minc-1,#fun+maxc-1}
		end
		for index,_ in pairs(mat) do
			Auxiliary.AddCodeList(c,index)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
		e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
		c:RegisterEffect(e1)
	end
	
	--require("script/procedure.lua")
end