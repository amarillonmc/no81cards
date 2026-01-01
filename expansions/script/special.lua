function Auxiliary.PreloadUds()
	PreloadUds_Done=true
	
	--[[local _IsSetCard=Card.IsSetCard
	Card.IsSetCard=function(c,setname,...)
						if setname==0x1cc then return _IsSetCard(c,0x1cc,...) or _IsSetCard(c,0x2cc,...) end
						return _IsSetCard(c,setname,...)
					end--]]

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
	EFFECT_FLAG_COPY_INHERIT=EFFECT_FLAG_COPY_INHERIT or 0x2000
	EFFECT_FLAG_COPY=EFFECT_FLAG_COPY or 0x2000

	table_range=table_range or {}
	effect_handler=effect_handler or {}
	effect_registered=effect_registered or {}
	require_list=require_list or {}
	
	--[[if not loadfile and Card.CopyEffect then
		function loadfile(str)
			require_list=require_list or {}
			local name=nil
			for word in string.gmatch(str,"%d+") do
				name=word
			end
			if not name then error("调用了文件名不为卡号的库。",2) return end
			return function()
						local g=Duel.GetFieldGroup(0,0xff,0xff)
						if #g>0 then
							local cid=g:GetFirst():CopyEffect(name,RESET_CHAIN)
							g:GetFirst():ResetEffect(cid,RESET_COPY)
						end
					end
		end
		function dofile(str)
			local f=loadfile(str)
			if f then f() end
		end
		function require(str)
			local f=loadfile(str)
			if f then f() end
		end
	end--]]
	if not require and loadfile then
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
	end
	if not require and Duel.LoadScript then
		function require(str)
			require_list=require_list or {}
			local name=str
			for word in string.gmatch(str,"[^/]+") do
				name=word
			end
			if not string.find(name,"%.") then name=name..".lua" end
			if not require_list[str] then
				require_list[str]=Duel.LoadScript(name)
			end
			return require_list[str]
		end
	end
	if not Duel.LoadScript and loadfile then
		function Duel.LoadScript(str)
			require_list=require_list or {}
			str="expansions/script/"..str
			if not require_list[str] then
				if string.find(str,"%.") then
					require_list[str]=loadfile(str)
				else
					require_list[str]=loadfile(str..".lua")
				end
				pcall(require_list[str])
			end
			return require_list[str]
		end
	end
	if not dofile and Duel.LoadScript then
		function dofile(str)
			require_list=require_list or {}
			local name=str
			for word in string.gmatch(str,"[^/]+") do
				name=word
			end
			if not require_list[str] then
				require_list[str]=Duel.LoadScript(name)
			end
			return require_list[str]
		end
		function loadfile(str)
			require_list=require_list or {}
			local name=str
			for word in string.gmatch(str,"[^/]+") do
				name=word
			end
			return function()
						if not require_list[str] then
							require_list[str]=Duel.LoadScript(name)
						end
						return require_list[str]
					end
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
	
	local _CreateEffect=_Effect.CreateEffect
	function Effect.CreateEffect(c,...)
		if aux.GetValueType(c)~="Card" then error("Effect.CreateEffect没有输入正确的Card参数。",2) return end
		local e=_CreateEffect(c,...)
		if e and c then effect_handler[e]=c end
		return e
	end
	local _SetRange=_Effect.SetRange
	function Effect.SetRange(e,r,...)
		if e and r then table_range[e]=r end
		return _SetRange(e,r,...)
	end
	local _Clone=_Effect.Clone
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
			error("Effect.GetRange没有及时加载该效果的Range信息。",2)
			return 0
		end
	end
	if not Card.GetLinkMarker then
		function Card.GetLinkMarker(c)
			local res=0
			for i=0,8 do
				if i~=4 and c:IsLinkMarker(1<<i) then res=res|(1<<i) end
			end
			return res
		end
	end
	
	local _CRegisterEffect=Card.RegisterEffect
	function Card.RegisterEffect(c,e,...)
		if aux.GetValueType(c)~="Card" then error("Card.RegisterEffect没有输入正确的Card参数。",2) return end
		if aux.GetValueType(e)~="Effect" then error("Card.RegisterEffect没有输入正确的Effect参数。",2) return end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not table_range[e] then
			table_range[e]=LOCATION_HAND+LOCATION_SZONE
		elseif e:IsHasType(EFFECT_TYPE_EQUIP) and not table_range[e] then
			table_range[e]=LOCATION_SZONE
		elseif e:IsHasType(EFFECT_TYPE_FLIP) and not table_range[e] then
			table_range[e]=LOCATION_MZONE
		elseif e:IsHasType(EFFECT_TYPE_XMATERIAL) and not table_range[e] then
			table_range[e]=LOCATION_OVERLAY
		end
		if e:IsHasType(EFFECT_TYPE_SINGLE) and e:IsHasType(EFFECT_TYPE_TRIGGER_O) and e:GetCode()==EVENT_TO_DECK and not c:IsExtraDeckMonster() then
			e:SetType(EFFECT_TYPE_QUICK_O)
			e:SetRange(LOCATION_DECK)
			local con=e:GetCondition() or aux.TRUE
			e:SetCondition(function(e,tp,eg,...) return eg:IsContains(e:GetHandler()) and con(e,tp,eg,...) end)
		end
		local eid=_CRegisterEffect(c,e,...)
		if e and eid then effect_registered[e]=true end
		return eid
	end
	local _DRegisterEffect=Duel.RegisterEffect
	function Duel.RegisterEffect(e,p,...)
		if aux.GetValueType(e)~="Effect" then error("Duel.RegisterEffect没有输入正确的Effect参数。",2) return end
		_DRegisterEffect(e,p,...)
		if e then effect_registered[e]=true end
	end

	local _GetHandler=Effect.GetHandler
	function Effect.GetHandler(e,...)
		--warning!!!
		if _Effect.IsHasType(e,EFFECT_TYPE_XMATERIAL) and not effect_registered[e] and Duel.Exile then return effect_handler[e] end
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
		local ext_params={...}
		local cp=nil
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
		elseif cg and #ext_params>=2 and ext_params[2]&REASON_COST>0 then
			local re=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
			if re and cg:IsContains(re:GetHandler()) then cp=true end
		end
		local res=_SendtoDeck(g,top,...)
		if cp then Duel.ConfirmCards(1-Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER),Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT):GetHandler()) end
		return res
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

	local _ReturnToField=Duel.ReturnToField
	function Duel.ReturnToField(c,...)
		local res=_ReturnToField(c,...)
		if res then
			c:SetStatus(0x100,false)
		end
		return res
	end

	local _Draw=Duel.Draw
	function Duel.Draw(p,ct,...)
		if ct<=0 then return 0 end
		return _Draw(p,ct,...)
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
	
	--piece of shit
	function Auxiliary.AddFusionProcMixRep(fcard,sub,insf,fun1,minc,maxc,...)
		if fcard:IsStatus(STATUS_COPYING_EFFECT) then return end
		local val={fun1,...}
		local fun={}
		local mat={}
		for i=1,#val do
			if type(val[i])=='function' then
				fun[i]=function(c,fc,subm,mg,sg) return val[i](c,fc,subm,mg,sg) and not c:IsHasEffect(6205579) end
			elseif type(val[i])=='table' then
				fun[i]=function(c,fc,subm,mg,sg)
						for _,fcode in ipairs(val[i]) do
							if type(fcode)=='function' then
								if fcode(c,fc,subm,mg,sg) and not c:IsHasEffect(6205579) then return true end
							elseif type(fcode)=='number' then
								if c:IsFusionCode(fcode) or (subm and c:CheckFusionSubstitute(fc)) then return true end
							end
						end
						return false
				end
				for _,fcode in ipairs(val[i]) do
					if type(fcode)=='number' then mat[fcode]=true end
				end
			elseif type(val[i])=='number' then
				fun[i]=function(c,fc,subm) return c:IsFusionCode(val[i]) or (subm and c:CheckFusionSubstitute(fc)) end
				local tmp=val[i]
				mat[tmp]=true
			end
		end
		local mt=getmetatable(fcard)
		if mt.material==nil then
			mt.material=mat
		end
		if mt.material_count==nil then
			mt.material_count={#fun+minc-1,#fun+maxc-1}
		end
		for index,_ in pairs(mat) do
			Auxiliary.AddCodeList(fcard,index)
		end
		local e1=Effect.CreateEffect(fcard)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
		e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
		fcard:RegisterEffect(e1)
	end
	function Auxiliary.FConditionMixRep(insf,sub,fun1,minc,maxc,...)
		local funs={...}
		return  function(e,g,gc,chkfnf)
					if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
					local c=e:GetHandler()
					local tp=c:GetControler()
					local hexsealed=chkfnf&0x100>0
					local notfusion=chkfnf&0x200>0
					local sub2=(sub or hexsealed) and not notfusion
					local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub2,notfusion,fun1,table.unpack(funs))
					if gc then
						if not mg:IsContains(gc) then return false end
						local sg=Group.CreateGroup()
						return Auxiliary.FSelectMixRep(gc,tp,mg,sg,c,sub2,chkfnf,fun1,minc,maxc,table.unpack(funs))
					end
					local sg=Group.CreateGroup()
					return mg:IsExists(Auxiliary.FSelectMixRep,1,nil,tp,mg,sg,c,sub2,chkfnf,fun1,minc,maxc,table.unpack(funs))
				end
	end
	function Auxiliary.FOperationMixRep(insf,sub,fun1,minc,maxc,...)
		local funs={...}
		return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
					local c=e:GetHandler()
					local tp=c:GetControler()
					local hexsealed=chkfnf&0x100>0
					local notfusion=chkfnf&0x200>0
					local sub2=(sub or hexsealed) and not notfusion
					local cancel=notfusion and Duel.GetCurrentChain()==0
					local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub2,notfusion,fun1,table.unpack(funs))
					local sg=Group.CreateGroup()
					if gc then sg:AddCard(gc) end
					while sg:GetCount()<maxc+#funs do
						local cg=mg:Filter(Auxiliary.FSelectMixRep,sg,tp,mg,sg,c,sub2,chkfnf,fun1,minc,maxc,table.unpack(funs))
						if cg:GetCount()==0 then break end
						local finish=Auxiliary.FCheckMixRepGoal(tp,mg,sg,c,sub2,chkfnf,fun1,minc,maxc,table.unpack(funs))
						local cancel_group=sg:Clone()
						if gc then cancel_group:RemoveCard(gc) end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local tc=cg:SelectUnselect(cancel_group,tp,finish,cancel,minc+#funs,maxc+#funs)
						if not tc then
							if not finish then sg:Clear() end
							break
						end
						if sg:IsContains(tc) then
							sg:RemoveCard(tc)
						else
							sg:AddCard(tc)
						end
					end
					Duel.SetFusionMaterial(sg)
				end
	end
	function Auxiliary.FCheckMixRep(sg,mg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
		if fun2 then
			return sg:IsExists(Auxiliary.FCheckMixRepFilter,1,g,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
		else
			local ct1=sg:FilterCount(fun1,g,fc,sub,mg,sg)
			local ct2=sg:FilterCount(fun1,g,fc,false,mg,sg)
			return ct1==sg:GetCount()-g:GetCount() and ct1-ct2<=1
		end
	end
	function Auxiliary.FCheckMixRepFilter(c,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
		if fun2(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false,mg,sg)
			local res=Auxiliary.FCheckMixRep(sg,mg,g,fc,sub,chkf,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
		return false
	end
	function Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf)
		local not_fusion=chkfnf&(0x100|0x200)>0
		if not not_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
		if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
		if Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then return false end
		return true
	end
	function Auxiliary.FCheckMixRepGoal(tp,mg,sg,fc,sub,chkfnf,fun1,minc,maxc,...)
		local chkf=chkfnf&0xff
		if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
		if not (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0) then return false end
		if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then return false end
		if not Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf) then return false end
		local g=Group.CreateGroup()
		return Auxiliary.FCheckMixRep(sg,mg,g,fc,sub,chkf,fun1,minc,maxc,...)
	end
	function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
		for i,f in ipairs({...}) do
			if f(c,fc,sub,mg,sg) then
				g:AddCard(c)
				local subf=sub and f(c,fc,false,mg,sg)
				local t={...}
				table.remove(t,i)
				local res=cond(tp,mg,sg,g,fc,subf,chkfnf,fun1,minc,maxc,table.unpack(t))
				g:RemoveCard(c)
				if res then return true end
			end
		end
		if maxc>0 then
			if fun1(c,fc,sub,mg,sg) then
				g:AddCard(c)
				local subf1=sub and fun1(c,fc,false,mg,sg)
				local res=cond(tp,mg,sg,g,fc,subf1,chkfnf,fun1,minc-1,maxc-1,...)
				g:RemoveCard(c)
				if res then return true end
			end
		end
		return false
	end
	function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
		if g:GetCount()<sg:GetCount() then
			return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
		else
			return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
		end
	end
	function Auxiliary.FCheckMixRepSelected(c,...)
		return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
	end
	function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
		local chkf=chkfnf&0xff
		if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
		if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
			if minc<=0 and #{...}==0 and Auxiliary.FCheckMixRepGoalCheck(tp,g,fc,chkfnf) then return true end
			return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
		else
			return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
		end
	end
	function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
		if fun2 then
			if fun2(c,fc,sub,mg,sg) then
				sg:AddCard(c)
				g:AddCard(c)
				local subf2=sub and fun2(c,fc,false,mg,sg)
				local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,subf2,chkf,fun1,minc,maxc,...)
				sg:RemoveCard(c)
				g:RemoveCard(c)
				return res
			end
		elseif maxc>0 and fun1(c,fc,sub,mg,sg) then
			sg:AddCard(c)
			g:AddCard(c)
			local subf1=sub and fun1(c,fc,false,mg,sg)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,subf1,chkf,fun1,minc-1,maxc-1)
			sg:RemoveCard(c)
			g:RemoveCard(c)
			return res
		end
		return false
	end
	function Auxiliary.FCheckSelectMixRepM(c,tp,...)
		return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
			and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
	end
	function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,chkfnf,...)
		sg:AddCard(c)
		local res=false
		if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
			res=false
		elseif Auxiliary.FCheckMixRepGoal(tp,mg,sg,fc,sub,chkfnf,...) then
			res=true
		else
			local g=Group.CreateGroup()
			res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,chkfnf,...)
		end
		sg:RemoveCard(c)
		return res
	end

	Auxiliary.ExtraPendulumChecklist=0
	local pendcon=Auxiliary.PendCondition
	function Auxiliary.PendCondition(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and (#eset==0 or Auxiliary.ExtraPendulumChecklist&(0x1<<tp)~=0) then return false end
		return pendcon(e,c,og)
	end
	function Auxiliary.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
		local tg=nil
		local loc=0
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
		local ft=Duel.GetUsableMZoneCount(tp)
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		if ect and ect<ft2 then ft2=ect end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 then ft1=1 end
			if ft2>0 then ft2=1 end
			ft=1
		end
		if ft1>0 then loc=loc|LOCATION_HAND end
		if ft2>0 then loc=loc|LOCATION_EXTRA end
		if og then
			tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale,eset)
		else
			tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
		end
		local ce=nil
		local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
		local b2=#eset>0 and Auxiliary.ExtraPendulumChecklist&(0x1<<tp)==0
		if b1 and b2 then
			local options={1163}
			for _,te in ipairs(eset) do
				table.insert(options,te:GetDescription())
			end
			local op=Duel.SelectOption(tp,table.unpack(options))
			if op>0 then
				ce=eset[op]
			end
		elseif b2 and not b1 then
			local options={}
			for _,te in ipairs(eset) do
				table.insert(options,te:GetDescription())
			end
			local op=Duel.SelectOption(tp,table.unpack(options))
			ce=eset[op+1]
		end
		if ce then
			tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
		local g=tg:SelectSubGroup(tp,Auxiliary.TRUE,true,1,math.min(#tg,ft))
		Auxiliary.GCheckAdditional=nil
		if not g then return end
		if ce then
			Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
			ce:UseCountLimit(tp)
			Auxiliary.ExtraPendulumChecklist=Auxiliary.ExtraPendulumChecklist|(0x1<<tp)
		else
			Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
		end
		sg:Merge(g)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	end
		
	--require("script/procedure.lua")
end