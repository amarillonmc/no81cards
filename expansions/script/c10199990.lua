--version 20.02.18
if not pcall(function() require("expansions/script/c10199991") end) then require("script/c10199991") end
local m=10199990
local vm=10199991
local Version_Number=20200218

-----------------------"Part_Effect_Base"-----------------------

--Effect: Get default hint string for Duel.Hint ,use in effect target
function rsef.GetDefaultHintString(pcatelist,loc1,loc2,hintstring)
	if hintstring then 
		return type(hintstring)=="table" and aux.Stringid(hintstring[1],hintstring[2]) or hintstring
	end
	local hint=0
	if istarget then hint=HINTMSG_TARGET end 
	if (type(loc1)~="number" or (loc1 and loc1>0)) and (not loc2 or loc2==0) then hint=HINTMSG_SELF end
	if (type(loc2)=="number" and loc2>0) and (not loc1 or loc1==0) then hint=HINTMSG_OPPO end
	local hintlist= { HINTMSG_DESTROY,HINTMSG_RELEASE,HINTMSG_REMOVE,HINTMSG_ATOHAND,HINTMSG_TODECK,
	HINTMSG_TOGRAVE,0,HINTMSG_DISCARD,HINTMSG_SUMMON,HINTMSG_SPSUMMON,
	0,HINTMSG_POSCHANGE,HINTMSG_CONTROL,rshint.dis,0,
	0,0,HINTMSG_EQUIP,0,0,
	rshint.ad,rshint.ad,HINTMSG_FACEUP,0,0, 
	0,HINTMSG_FACEUP,0,0,0,
	rshint.te } 
	for _,cate in pairs(pcatelist) do 
		local tf,list=rsof.Table_List(rscate.catelist,cate) 
		if tf then
			local hint2=hintlist[list]
			if hint2>0 then
				hint=hint2
			end 
		end
	end 
	-- destroy and remove 
	if rsof.Table_List(pcatelist,"des_rm") or rsof.Table_List(pcatelist,"des,rm") or (rsof.Table_List(pcatelist,"des") and rsof.Table_List(pcatelist,"rm")) then
		hint=HINTMSG_DESTROY 
	end
	-- return to hand
	if rsof.Table_List(pcatelist,"th") and
		((type(loc1)=="number" and loc1&LOCATION_ONFIELD ~=0) or (loc2 and loc2&LOCATION_ONFIELD ~=0)) then
		hint=HINTMSG_RTOHAND 
	end
	-- return to grave
	if rsof.Table_List(pcatelist,"tg") and
		((type(loc1)=="number" and loc1&LOCATION_REMOVED  ~=0) or (loc2 and loc2&LOCATION_REMOVED ~=0)) then
		hint=rshint.rtg
	end
	return hint 
end
--Effect: Get reset, for some effect use like "banish it until XXXX"
function rsef.GetResetPhase(selfplayer,resetct,resetplayer,resetphase)
	if not resetphase then resetphase=PHASE_END end
	local currentphase=Duel.GetCurrentPhase()
	local currentplayer=Duel.GetTurnPlayer()
	local reset=RESET_PHASE+resetphase 
	if not resetct then
		return {0,1,resetplayer}
	end
	if resetct==0 then
		return {reset,1,currentplayer}
	end
	if resetplayer then
		if resetplayer==selfplayer then reset=reset+RESET_SELF_TURN 
		else reset=reset+RESET_OPPO_TURN 
		end
	end
	if resetct==1 then
		if currentphase<=resetphase and (not resetplayer or currentplayer==resetplayer) then
			return {reset,2,resetplayer}
		else
			return {reset,1,resetplayer}
		end
	end
	if resetct>1 then
		return {reset,resetct,resetplayer}
	end
end
--Effect: Get register card
function rsef.GetRegisterCard(cardtbl)
	local tc1,val2=nil
	local ignore=false
	if type(cardtbl)=="table" then
		tc1=cardtbl[1]
		if #cardtbl==1 then
			val2=tc1		  
		elseif #cardtbl==2 then
			if type(cardtbl[2])~="boolean" then
				val2=cardtbl[2]
			else
				val2=tc1
				ignore=cardtbl[2]
			end
		elseif #cardtbl==3 then
			val2=cardtbl[2]
			ignore=cardtbl[3]
		end
	else
	   tc1,val2=cardtbl,cardtbl
	end
	return tc1,val2,ignore
end
--Effect: Get default activate or apply range
function rsef.GetRegisterRange(cardtbl)
	local range=nil
	local tc1,tc2=rsef.GetRegisterCard(cardtbl)
	if aux.GetValueType(tc2)~="Card" then return nil end
	if tc2:IsType(TYPE_MONSTER) then range=LOCATION_MZONE 
	elseif tc2:IsType(TYPE_PENDULUM) then range=LOCATION_PZONE 
	elseif tc2:IsType(TYPE_FIELD) then range=LOCATION_FZONE  
	elseif tc2:IsType(TYPE_SPELL+TYPE_TRAP) then range=LOCATION_SZONE 
	end
	if tc2:IsLocation(LOCATION_GRAVE) then range=LOCATION_GRAVE end
	return range 
end
--Effect: Get Flag for SetProperty 
function rsef.GetRegisterProperty(mixflag)
	local flagstringlist={"tg","ptg","de","dsp","dcal","ii","sa","ir","sr","bs","uc","cd","cn","ch","lz","at","sp"}
	return rsof.Mix_Value_To_Table(mixflag,flagstringlist,rsflag.flaglist)
end
rsflag.GetRegisterProperty=rsef.GetRegisterProperty
--Effect: Get Category for SetCategory or SetOperationInfo
function rsef.GetRegisterCategory(mixcategory)
	local catestringlist={"des","res","rm","th","td","tg","disd","dish","sum","sp","tk","pos","con","dis","diss","dr","se","eq","dam","rec","atk","def","ct","coin","dice","lg","lv","neg","an","fus","te","ga"}
	return rsof.Mix_Value_To_Table(mixcategory,catestringlist,rscate.catelist)
end
rscate.GetRegisterCategory=rsef.GetRegisterCategory
--Effect: Clone Effect 
function rsef.RegisterClone(cardtbl,e1,...)
	local clonelist={...}
	local e2=e1:Clone()
	for k,value1 in pairs(clonelist) do 
		if k&1==1 and type(value1)=="string" then
			local value2=clonelist[k+1]
			local clonetypelist1={"code","type","loc","con","cost","tg","op","label","labobj","value"}
			local effecttypelist1={Effect.SetCode,Effect.SetType,Effect.SetRange,Effect.SetCondition,Effect.SetCost,Effect.SetTarget,Effect.SetOperation,Effect.SetLabel,Effect.SetLabelObject,Effect.SetValue}
			local bool,k=rsof.Table_List(clonetypelist1,value1)
			if bool and k then
				local f=effecttypelist1[k]
				f(e2,value2)
			end
			if value1=="desc" then rsef.RegisterDescription(e2,value2) end
			if value1=="flag" then e2:SetProperty(rsflag.GetRegisterProperty(value2)) end
			if value1=="cate" then e2:SetCategory(rscate.GetRegisterCategory(value2)) end
			if value1=="reset" then rsef.RegisterReset(e2,value2) end
			if value1=="timing" then rsef.RegisterTiming(e2,value2) end
			if value1=="tgrange" then rsef.RegisterTargetRange(e2,value2) end
		end
	end
	local _,fid=rsef.RegisterEffect(cardtbl,e2)
	return e2,fid
end 
--Effect: Make Ignition Effect Become Quick Effect
function rsef.RegisterOPTurn(cardtbl,e1,con2,timingtbl)
	if not timingtbl then timingtbl={0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE } end
	local e2,fid=rsef.RegisterClone(cardtbl,e1,"type",EFFECT_TYPE_QUICK_O,"code",EVENT_FREE_CHAIN,"timing",timingtbl)
	local con1=e1:GetCondition()
	if not con1 then con1=aux.TRUE end
	e1:SetCondition(aux.AND(con1,aux.NOT(con2)))
	e2:SetCondition(aux.AND(con1,con2))
	return e2,fid
end 
rsef.QO_OPPONENT_TURN=rsef.RegisterOPTurn
--Effect: Mix X Effect in 1
function rsef.RegisterMix(cardtbl,code,desctbl,ctlimittbl,catelist,flaglist,range,con,cost,e0,...)
	local elist={e0,...}
	desctbl=desctbl or rshint.choose
	code=code or e0:GetCode()
	local e1
	if e0:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e1=rsef.ACT(cardtbl,code,desctbl,ctlimittbl,catelist,flaglist,con,cost,rstg.targetmix(elist))
	elseif e0:IsHasType(EFFECT_TYPE_IGNITION) then
		range=range or e0:GetActivateLocation()
		e1=rsef.I(cardtbl,desctbl,ctlimittbl,catelist,flaglist,range,con,cost,rstg.targetmix(elist))
	elseif e0:IsHasType(EFFECT_TYPE_QUICK_O) then
		range=range or e0:GetActivateLocation()
		e1=rsef.QO(cardtbl,code,desctbl,ctlimittbl,catelist,flaglist,range,con,cost,rstg.targetmix(elist))
	elseif e0:IsHasType(EFFECT_TYPE_TRIGGER_O) and e0:IsHasType(EFFECT_TYPE_FIELD) then
		range=range or e0:GetActivateLocation()
		con=con or e0:GetCondition()
		e1=rsef.FTO(c,code,desctbl,ctlimittbl,catelist,flaglist,range,con,cost,rstg.targetmix(elist))
	elseif e0:IsHasType(EFFECT_TYPE_TRIGGER_O) and e0:IsHasType(EFFECT_TYPE_SINGLE) then
		con=con or e0:GetCondition()
		e1=rsef.STO(c,code,desctbl,ctlimittbl,catelist,flaglist,con,cost,rstg.targetmix(elist))
	end
	for _,e in pairs(elist) do
		e:SetRange(0)
	end
	return e1
end
function rstg.targetmixcheck(e,tp,eg,ep,ev,re,r,rp,chk,elist)
	local rightelist={}
	local selectlist={}
	for _,e0 in pairs(elist) do 
		local con,tg,code=e0:GetCondition(),e0:GetTarget(),e0:GetCode()
		local conres=not con or con(e,tp,eg,ep,ev,re,r,rp)
		local tgres=not tg or tg(e,tp,eg,ep,ev,re,r,rp,chk)
		local code=e0:GetCode()
		local coderes= not code and true or (code==EVENT_FREE_CHAIN or Duel.CheckEvent(code))
		if conres and tgres and coderes then 
			table.insert(rightelist,e0)
			table.insert(selectlist,true)
			table.insert(selectlist,e0:GetDescription())
		end
	end
	return rightelist,selectlist
end
function rstg.targetmix(elist)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local rightelist,selectlist=rstg.targetmixcheck(e,tp,eg,ep,ev,re,r,rp,0,elist)
		if chk==0 then 
			return #rightelist>0
		end
		local op=rsop.SelectOption(tp,table.unpack(selectlist))
		local e0=rightelist[op]
		e:SetProperty(e0:GetProperty() or 0)
		e:SetCategory(e0:GetCategory() or 0)
		e:SetOperation(e0:GetOperation() or aux.TRUE)
		e0:GetTarget()(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function rsef.RegisterMix_Easy(cardtbl,ctlimittbl,con,cost,e0,...)
	return rsef.RegisterMix(cardtbl,nil,nil,nil,nil,nil,nil,con,cost,e0,...)
end
--Effect: Register Condition, Cost, Target and Operation 
function rsef.RegisterSolve(e,con,cost,tg,op)
	local code=e:GetOwner():GetCode()
	if con then
		if type(con)~="function" then
			Debug.Message(code .. " RegisterSolve con must be function")
		end
		e:SetCondition(con)
	end
	if cost then
		if type(cost)~="function" then
			Debug.Message(code .. " RegisterSolve cost must be function")
		end
		e:SetCost(cost)
	end
	if tg then
		if type(tg)~="function" then
			Debug.Message(code .. " RegisterSolve tg must be function")
		end
		e:SetTarget(tg)
	end
	if op then
		if type(op)~="function" then
			Debug.Message(code .. " RegisterSolve op must be function")
		end
		e:SetOperation(op)
	end
end
Effect.RegisterSolve=rsef.RegisterSolve
--Effect: Register Property and Category
function rsef.RegisterCateFlag(e,cate,flag)
	if cate then
		local cate2=rsef.GetRegisterCategory(cate)
		if cate2>0 then
			e:SetCategory(cate2) 
		end
	end
	if flag then
		local flag2=rsef.GetRegisterProperty(flag)
		if flag2>0 then
			e:SetProperty(flag2) 
		end
	end
end
--Effect: Register Effect Description
function rsef.RegisterDescription(e,desctbl,isreturn)
	if desctbl then
		if type(desctbl)=="table" then
			if isreturn then return aux.Stringid(desctbl[1],desctbl[2]) end
			e:SetDescription(aux.Stringid(desctbl[1],desctbl[2]))
		else
			if isreturn then return desctbl end
			e:SetDescription(desctbl)
		end
	end 
end
--Effect: Register Effect Count limit
function rsef.RegisterCountLimit(e,ctlimittbl,isreturn)
	if ctlimittbl then
		local limitcount,limitcode=0,0
		if type(ctlimittbl)=="table" then
			if #ctlimittbl==1 then
				if ctlimittbl[1]<=100 then
					limitcount=ctlimittbl[1]
				else
					limitcount=1
					limitcode=ctlimittbl[1]
				end
			elseif #ctlimittbl==2 then
				limitcount=ctlimittbl[1]
				if value==3 or value==0x1 then
					limitcode=EFFECT_COUNT_CODE_SINGLE 
				else
					limitcode=ctlimittbl[2]
				end
			elseif #ctlimittbl==3 then
				limitcount=ctlimittbl[1]
				limitcode=ctlimittbl[2]
				local value=ctlimittbl[3]
				if value==1 then 
					limitcode=limitcode+EFFECT_COUNT_CODE_OATH 
				elseif value==2 then
					limitcode=limitcode+EFFECT_COUNT_CODE_DUEL 
				else 
					limitcode=limitcode+value
				end
			end
		else
			if limitcount<=100 then
				limitcount=ctlimittbl
			else
				limitcount=1
				limitcode=ctlimittbl
			end
		end
		if isreturn then return limitcount,limitcode end
		e:SetCountLimit(limitcount,limitcode)
	end
end
--Effect: Register Effect Target range
function rsef.RegisterTargetRange(e,tgrangetbl)
	if tgrangetbl then
		if type(tgrangetbl)=="table" then
			if #tgrangetbl==1 then
				e:SetTargetRange(tgrangetbl[1],tgrangetbl[1]) 
			else
				e:SetTargetRange(tgrangetbl[1],tgrangetbl[2])
			end
		else
			e:SetTargetRange(tgrangetbl) 
		end
	end
end
--Effect: Register Effect Timing 
function rsef.RegisterTiming(e,timingtbl)
	if timingtbl then
		if type(timingtbl)=="table" then
			if #timingtbl==1 then
				e:SetHintTiming(timingtbl[1]) 
			else
				e:SetHintTiming(timingtbl[1],timingtbl[2])
			end
		else
			e:SetHintTiming(timingtbl) 
		end
	end
end
--Effect: Register Effect Reset way 
function rsef.RegisterReset(e,resettbl,isreturn)
	if resettbl then
		if type(resettbl)=="table" then
			if #resettbl==1 then
				if isreturn then return resettbl[1],1 end
				e:SetReset(resettbl[1]) 
			else
				if isreturn then return resettbl[1],resettbl[2] end
				e:SetReset(resettbl[1],resettbl[2])
			end
		else
			if isreturn then return resettbl,1 end
			e:SetReset(resettbl) 
		end
	end
end
--Effect: Register Effect Final
function rsef.RegisterEffect(cardtbl,e)
	local tc1,val2,ignore=rsef.GetRegisterCard(cardtbl)
	if type(val2)=="number" and (val2==0 or val2==1) then
		Duel.RegisterEffect(e,val2)
	else
		val2:RegisterEffect(e,ignore)
	end
	local fid=e:GetFieldID()
	return e,fid
end
--Effect: Register Effect Attributes
function rsef.Register(cardtbl,effecttype,effectcode,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,val,tgrangetbl,timingtbl,resettbl)
	local tc1,val2,ignore=rsef.GetRegisterCard(cardtbl)
	local e=Effect.CreateEffect(tc1)
	if effecttype then
		e:SetType(effecttype)
	end
	if effectcode then
		e:SetCode(effectcode)
	end
	rsef.RegisterDescription(e,desctbl)
	rsef.RegisterCountLimit(e,ctlimittbl)
	rsef.RegisterCateFlag(e,cate,flag)
	if range then
		e:SetRange(range)
	end
	rsef.RegisterSolve(e,con,cost,tg,op)
	if val then
		e:SetValue(val)
	end
	rsef.RegisterTargetRange(e,tgrangetbl)
	rsef.RegisterTiming(e,timingtbl)
	rsef.RegisterReset(e,resettbl)
	local _,fid=rsef.RegisterEffect(cardtbl,e)
	return e,fid
end

-------------------"Part_Effect_SingleValue"-------------------

--Single Val Effect: Base set
function rsef.SV(cardtbl,code,val,range,con,resettbl,flag,desctbl,ctlimittbl)
	local tc1,tc2=rsef.GetRegisterCard(cardtbl)
	local flag2=rsef.GetRegisterProperty(flag)
	local flagtbl1={ EFFECT_IMMUNE_EFFECT,EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET,EFFECT_CHANGE_CODE,EFFECT_ADD_CODE,EFFECT_CHANGE_RACE,EFFECT_ADD_RACE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_ADD_ATTRIBUTE,EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,rscode.Utility_Xyz_Material,rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL }
	local flagtbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK }
	local tf1=rsof.Table_List(flagtbl1,code)
	local tf2=rsof.Table_List(flagtbl2,code)
	if (tf1 and tc1==tc2 and not resettbl) or (tf2 and not resettbl and tc1~=tc2) then 
		flag2=flag2|EFFECT_FLAG_SINGLE_RANGE 
	end
	if desctbl then flag2=flag2|EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(cardtbl,EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,nil,flag2,range,con,nil,nil,nil,val,nil,nil,resettbl)
end
--Single Val Effect: attribute base set (new)
function rsef.SV_ATTRIBUTE(cardtbl,atttbl,valtbl,con,resettbl,flag,desctbl,ctlimittbl)
	local c1,c2=rsef.GetRegisterCard(cardtbl)
	--case set 
	local codetblset={"atk","def","atkf","deff","batk","bdef"}  
	local codetblset2={EFFECT_SET_ATTACK,EFFECT_SET_DEFENSE,EFFECT_SET_ATTACK_FINAL,EFFECT_SET_DEFENSE_FINAL,EFFECT_SET_BASE_ATTACK,EFFECT_SET_BASE_DEFENSE }
	--case change 
	local codetblchange={"lv","rk","ls","rs","code","att","race","type","fusatt"}
	local codetblchange2={EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE }
	--case updata
	local codetblup={"atk+","def+","lv+","rk+","ls+","rs+"}
	local codetblup2={EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE }
	--case add 
	local codetbladd={"code+","att+","race+","set+","type+","fusatt+","fuscode+","fusset+","linkatt+","linkrace+","linkcode+","linkset+"}
	local codetbladd2={EFFECT_ADD_CODE,EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_SETCODE,EFFECT_ADD_TYPE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE }

	local totallist=rsof.Table_Mix(codetblset,codetblchange,codetblup,codetbladd)
	local totallist2=rsof.Table_Mix(codetblset2,codetblchange2,codetblup2,codetbladd2)

	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(atttbl,totallist,totallist2,valtbl)   
	local resulteffecttbl={}
	local rangelist={}
	rangelist["pzone"]={EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE }
	rangelist["nil"]={table.unpack(codetblset2)}
	for k,effectcode in ipairs(effectcodetbl) do
		local range=rsef.GetRegisterRange(cardtbl)
		if rsof.Table_List(rangelist["pzone"],effectcode) then range=LOCATION_PZONE end
		if rsof.Table_List(rangelist["nil"],effectcode) then range=nil end 
		if effectvaluetbl[k] then
			local e1=nil
			if type(effectvaluetbl[k])~="string" then
				e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
			else -- use for set code
				e1=rsef.SV(cardtbl,effectcode,0,range,con,resettbl,flag,desctbl)
				rsef.valinfo[e1]=effectvaluetbl[k]
				if c2:GetFlagEffect(rscode.Previous_Set_Code)==0 then
					local e2=rsef.SC({c2,true},EVENT_LEAVE_FIELD_P,nil,nil,"cd,uc",nil,rsef.presetop)
					c2:RegisterFlagEffect(rscode.Previous_Set_Code,0,0,1)
				end
			end
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)   
end 
function rsef.presetop(e,tp)
	local c=e:GetHandler()
	rscf.Previous_Set_Code_List[c]={c:IsHasEffect(EFFECT_ADD_SETCODE)} 
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(cardtbl,indstbl,valtbl,con,resettbl,flag,desctbl,ctlimittbl)
	local codetbl1={"battle","effect","ct","all"}
	local codetbl2={ EFFECT_INDESTRUCTABLE_BATTLE,EFFECT_INDESTRUCTABLE_EFFECT,EFFECT_INDESTRUCTABLE_COUNT,EFFECT_INDESTRUCTABLE }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(indstbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	for k,effectcode in ipairs(effectcodetbl) do 
		local val=effectvaluetbl[k]
		if not val then
			if effectcode~=EFFECT_INDESTRUCTABLE_COUNT then
				val=1
			else
				val=rsval.indbae()
			end
		end
		if indstype==EFFECT_INDESTRUCTABLE_COUNT and not ctlimittbl then
			ctlimittbl=1
		end
		local e1=rsef.SV(cardtbl,effectcode,val,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(cardtbl,val,con,resettbl,flag,desctbl)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(cardtbl)
	return rsef.SV(cardtbl,EFFECT_IMMUNE_EFFECT,val,range,con,resettbl,flag,desctbl)
end
--Single Val Effect: Directly set ATK & DEF 
function rsef.SV_SET(cardtbl,settypetbl,valtbl,con,resettbl,flag,desctbl)
	return rsef.SV_ATTRIBUTE(cardtbl,settypetbl,valtbl,con,resettbl,flag,desctbl)
end
--Single Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.SV_CHANGE(cardtbl,changetypetbl,valtbl,con,resettbl,flag,desctbl)
	return rsef.SV_ATTRIBUTE(cardtbl,changetypetbl,valtbl,con,resettbl,flag,desctbl)
end
--Single Val Effect: Update attribute 
function rsef.SV_UPDATE(cardtbl,uptypetbl,valtbl,con,resettbl,flag,desctbl)
	local stringlist=rsof.String_Number_To_Table(uptypetbl)
	local stringlist2={}
	for _,string in pairs(stringlist) do
		table.insert(stringlist2,string.."+")
	end
	return rsef.SV_ATTRIBUTE(cardtbl,stringlist2,valtbl,con,resettbl,flag,desctbl)
end 
--Single Val Effect: Add attribute
function rsef.SV_ADD(cardtbl,addtypetbl,valtbl,con,resettbl,flag,desctbl)
	return rsef.SV_UPDATE(cardtbl,addtypetbl,valtbl,con,resettbl,flag,desctbl)
end
--Single Val Effect: Material limit
function rsef.SV_CANNOT_BE_MATERIAL(cardtbl,lmattypetbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"fus","syn","xyz","link"}
	local codetbl2={ EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL }
	if not valtbl then valtbl=1 end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lmattypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],nil,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(cardtbl,tgtbl,valtbl,con,resettbl,flag,desctbl)
	local codetbl1={"battle","effect"}
	local codetbl2={ EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(tgtbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	for k,effectcode in ipairs(effectcodetbl) do
		local val=effectvaluetbl[k]
		if not val then
			if effectcode==EFFECT_CANNOT_BE_BATTLE_TARGET then
				val=aux.imval1
			else
				val=1
			end
		end
		local e1=rsef.SV(cardtbl,effectcode,val,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(cardtbl,lotbl,valtbl,con,resettbl,flag,desctbl) 
	local codetbl1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp","cost"}
	local codetbl2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION,EFFECT_CANNOT_USE_AS_COST }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Leave field redirect 
function rsef.SV_REDIRECT(cardtbl,redtbl,valtbl,con,resettbl,flag,desctbl) 
	local codetbl1={"tg","td","th","leave"}
	local codetbl2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not valtbl then valtbl={ LOCATION_REMOVED } end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(redtbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	--if not resettbl then resettbl=rsreset.ered end
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],nil,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Single Val Effect: Extra Procedure Materials
function rsef.SV_EXTRA_MATERIAL(cardtbl,proctbl,valtbl,con,resettbl,flag,desctbl,ctlimittbl,range)
	local codetbl1={"syn","xyz","link"}
	local codetbl2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or LOCATION_HAND 
	valtbl = valtbl or { aux.TRUE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(proctbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.SV(cardtbl,effectcode,effectvaluetbl[k],range,con,resettbl,flag,desctbl,ctlimittbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end

--Single Val Effect: Utility Procedure Materials
function rsef.SV_Utility_Xyz_Material(cardtbl,val,con,resettbl,flag,desctbl,ctlimittbl,range)
	val = val or 2
	range = range or LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE 
	local e1=rsef.SV(cardtbl,rscode.Utility_Xyz_Material,val,range,con,resettbl,flag,desctbl,ctlimittbl)
	return e1
end

-------------------"Part_Effect_FieldValue"-------------------

--Field Val Effect: Base set
function rsef.FV(cardtbl,code,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl,ctlimittbl)
	local flag2=rsef.GetRegisterProperty(flag)
	if desctbl then flag2=flag2|EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(cardtbl,EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,nil,flag2,range,con,nil,tg,nil,val,tgrangetbl,nil,resettbl)
end
--Field Val Effect: Updata some card attributes
function rsef.FV_UPDATE(cardtbl,uptypetbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"atk","def","lv","rk","ls","rs"}
	local codetbl2={ EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_DEFENSE,EFFECT_UPDATE_LEVEL,EFFECT_UPDATE_RANK,EFFECT_UPDATE_LSCALE,EFFECT_UPDATE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(uptypetbl,codetbl1,codetbl2,valtbl)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,LOCATION_MZONE } end
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	for k,effectcode in ipairs(effectcodetbl) do 
		if effectvaluetbl[k] and effectvaluetbl[k]~=0 then
			local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)  
end
--Field Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.FV_CHANGE(cardtbl,changetypetbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"lv","lvf","rk","rkf","code","att","race","type","fusatt","ls","rs"}
	local codetbl2={ EFFECT_CHANGE_LEVEL,EFFECT_CHANGE_LEVEL_FINAL,EFFECT_CHANGE_RANK,EFFECT_CHANGE_RANK_FINAL,EFFECT_CHANGE_CODE,EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_RACE,EFFECT_CHANGE_TYPE,EFFECT_CHANGE_FUSION_ATTRIBUTE,EFFECT_CHANGE_LSCALE,EFFECT_CHANGE_RSCALE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(changetypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	local tgrangetbl2=tgrangetbl
	for k,effectcode in ipairs(effectcodetbl) do 
		if effectvaluetbl[k] and effectvaluetbl[k]~=0 then
			if effectcode==EFFECT_CHANGE_LSCALE or effectcode==EFFECT_CHANGE_RSCALE then tgrangetbl2={ LOCATION_PZONE,LOCATION_PZONE } 
			else
				if not tgrangetbl then
					tgrangetbl2={ LOCATION_MZONE,LOCATION_MZONE } 
				end
			end
			local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl2,range,con,resettbl,flag,desctbl)
			table.insert(resulteffecttbl,e1)
		end
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Directly set other card attribute,except ATK & DEF
function rsef.FV_ADD(cardtbl,addtypetbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"code","set","att","race","fuscode","fusset","fusatt","linkcode","linkset","linkatt","linkrace"}
	local codetbl2={ EFFECT_ADD_CODE,EFFECT_ADD_SETCODE,EFFECT_ADD_ATTRIBUTE,EFFECT_ADD_RACE,EFFECT_ADD_FUSION_CODE,EFFECT_ADD_FUSION_SETCODE,EFFECT_ADD_FUSION_ATTRIBUTE,EFFECT_ADD_LINK_CODE,EFFECT_ADD_LINK_SETCODE,EFFECT_ADD_LINK_ATTRIBUTE,EFFECT_ADD_LINK_RACE } 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(addtypetbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	local tgrangetbl2=tgrangetbl or { LOCATION_MZONE,LOCATION_MZONE }
	for k,effectcode in ipairs(effectcodetbl) do 
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl2,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Cannot Disable 
function rsef.FV_CANNOT_DISABLE(cardtbl,distbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"dis","dise","act","sum","sp"} 
	local codetbl2={EFFECT_CANNOT_DISABLE,EFFECT_CANNOT_DISEFFECT,EFFECT_CANNOT_INACTIVATE,EFFECT_CANNOT_DISABLE_SUMMON,EFFECT_CANNOT_DISABLE_SPSUMMON }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(distbl,codetbl1,codetbl2,valtbl,true)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	local flag2=rsef.GetRegisterProperty(flag)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(effectcodetbl) do 
		local tg2=tg
		local tgrangetbl2=tgrangetbl 
		local val=nil
		if effectcode==EFFECT_CANNOT_DISABLE_SUMMON or EFFECT_CANNOT_DISABLE_SPSUMMON then
			flag2=flag2|EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE 
			tgrangetbl2=nil
		end
		if effectcode==EFFECT_CANNOT_DISEFFECT or effectcode==EFFECT_CANNOT_INACTIVATE then
			tg2=nil
			tgrangetbl2=nil
			val=effectvaluetbl[k]
			if not val then
				val=rsval.cdisneg()
			end
		end
		local e1=rsef.FV(cardtbl,effectcode,val,tg2,tgrangetbl2,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Cannot be battle or card effect target
function rsef.FV_CANNOT_BE_TARGET(cardtbl,tgtbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"battle","effect"}
	local codetbl2={ EFFECT_CANNOT_BE_BATTLE_TARGET,EFFECT_CANNOT_BE_EFFECT_TARGET }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(tgtbl,codetbl1,codetbl2,valtbl,true)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE 
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(effectcodetbl) do 
		local val=effectvaluetbl[k]
		if not val then
			if effectcode==EFFECT_CANNOT_BE_BATTLE_TARGET then
				val=aux.imval1
			else
				val=1
			end
		end
		local e1=rsef.FV(cardtbl,effectcode,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Cannot destroed 
function rsef.FV_INDESTRUCTABLE(cardtbl,indstbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl)
	local codetbl1={"battle","effect","ct","all"}
	local codetbl2={ EFFECT_INDESTRUCTABLE_BATTLE,EFFECT_INDESTRUCTABLE_EFFECT,EFFECT_INDESTRUCTABLE_COUNT,EFFECT_INDESTRUCTABLE }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(indstbl,codetbl1,codetbl2,valtbl,true)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	for k,effectcode in ipairs(effectcodetbl) do 
		local val=effectvaluetbl[k]
		if not val then
			if effectcode~=EFFECT_INDESTRUCTABLE_COUNT then
				val=1
			else
				val=rsval.indct()
			end
		end
		local e1=rsef.FV(cardtbl,effectcode,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Other Limit
function rsef.FV_LIMIT(cardtbl,lotbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp","res"}
	local codetbl2={ EFFECT_DISABLE,EFFECT_DISABLE_EFFECT,EFFECT_CANNOT_TRIGGER,EFFECT_CANNOT_ATTACK,EFFECT_CANNOT_ATTACK_ANNOUNCE,EFFECT_CANNOT_DIRECT_ATTACK,EFFECT_CANNOT_RELEASE,EFFECT_UNRELEASABLE_SUM,EFFECT_UNRELEASABLE_NONSUM,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_CHANGE_POSITION }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	if not tgrangetbl then tgrangetbl={ 0,LOCATION_MZONE } end
	for k,effectcode in ipairs(effectcodetbl) do 
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Other Limit (affect Player)
function rsef.FV_LIMIT_PLAYER(cardtbl,lotbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"act","sum","sp","th","dr","td","tg","res","rm","sbp","sm1","sm2","sdp","ssp","sset","mset","dish","disd","fp"}
	local codetbl2={ EFFECT_CANNOT_ACTIVATE,EFFECT_CANNOT_SUMMON,EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_CANNOT_TO_HAND,EFFECT_CANNOT_DRAW,EFFECT_CANNOT_TO_DECK,EFFECT_CANNOT_TO_GRAVE,EFFECT_CANNOT_RELEASE,EFFECT_CANNOT_REMOVE,EFFECT_CANNOT_BP,EFFECT_SKIP_M1,EFFECT_SKIP_M2,EFFECT_SKIP_DP,EFFECT_SKIP_SP,EFFECT_CANNOT_SSET,EFFECT_CANNOT_MSET,EFFECT_CANNOT_DISCARD_HAND,EFFECT_CANNOT_DISCARD_DECK,EFFECT_CANNOT_FLIP_SUMMON }
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(lotbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl) 
	if not tgrangetbl then tgrangetbl={ 0,1 } end
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_PLAYER_TARGET 
	for k,effectcode in ipairs(effectcodetbl) do 
		local tg2=tg
		local val=nil
		if effectcode==EFFECT_CANNOT_ACTIVATE then 
			if effectvaluetbl[k] then val=effectvaluetbl[k] 
			--[[else 
				val=function(e,re,rp)
					return not re:GetHandler():IsImmuneToEffect(e)
				end--]]
			end
			tg2=nil
		end
		local e1=rsef.FV(cardtbl,effectcode,val,tg2,tgrangetbl,range,con,resettbl,flag2,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Immue effects
function rsef.FV_IMMUNE_EFFECT(cardtbl,val,tg,tgrangetbl,con,resettbl,flag,desctbl)
	if not val then val=rsval.imes end
	local range=rsef.GetRegisterRange(cardtbl)
	if not tgrangetbl then tgrangetbl={ LOCATION_MZONE,0 } end
	return rsef.FV(cardtbl,EFFECT_IMMUNE_EFFECT,val,tg,tgrangetbl,range,con,resettbl,flag,desctbl)
end
--Field Val Effect: Leave field redirect 
function rsef.FV_REDIRECT(cardtbl,redtbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl) 
	local codetbl1={"tg","td","th","leave"}
	local codetbl2={ EFFECT_TO_GRAVE_REDIRECT,EFFECT_TO_DECK_REDIRECT,EFFECT_TO_HAND_REDIRECT,EFFECT_LEAVE_FIELD_REDIRECT }
	if not valtbl then valtbl={ LOCATION_REMOVED } end
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(redtbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	local range=rsef.GetRegisterRange(cardtbl)
	if not tgrangetbl then tgrangetbl={ 0,0xff } end
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE 
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag2,desctbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)
end
--Field Val Effect: Extra Procedure Materials
function rsef.FV_EXTRA_MATERIAL(cardtbl,proctbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl,ctlimittbl,range) 
	local codetbl1={"syn","xyz","link"}
	local codetbl2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or rsef.GetRegisterRange(cardtbl) 
	valtbl = valtbl or { aux.TRUE }
	tgrangetbl  =   tgrangetbl or {LOCATION_HAND,0}
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(proctbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,range,con,resettbl,flag2,desctbl,ctlimittbl)
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)	
end
--Field Val Effect: Extra Procedure Materials for self
function rsef.FV_EXTRA_MATERIAL_SELF(cardtbl,proctbl,valtbl,tg,tgrangetbl,con,resettbl,flag,desctbl,ctlimittbl) 
	local codetbl1={"syn","xyz","link"}
	local codetbl2={ rscode.Extra_Synchro_Material,rscode.Extra_Xyz_Material,EFFECT_EXTRA_LINK_MATERIAL } 
	valtbl = valtbl or { function(e,c,mg) return c==e:GetHandler() end }
	tgrangetbl  =   tgrangetbl or {LOCATION_HAND,0}
	local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE + EFFECT_FLAG_UNCOPYABLE 
	local effectcodetbl,effectvaluetbl=rsof.Table_Suit(proctbl,codetbl1,codetbl2,valtbl)
	local resulteffecttbl={}
	for k,effectcode in ipairs(effectcodetbl) do
		local e1=rsef.FV(cardtbl,effectcode,effectvaluetbl[k],tg,tgrangetbl,LOCATION_EXTRA,con,resettbl,flag2,desctbl,ctlimittbl) 
		table.insert(resulteffecttbl,e1)
	end
	return table.unpack(resulteffecttbl)	 
end
--Field Val Effect: Utility Procedure Materials
function rsef.FV_Utility_Xyz_Material(cardtbl,val,tg,tgrangetbl,con,resettbl,flag,desctbl,ctlimittbl,range)
	val = val or 2
	tgrangetbl  =   tgrangetbl or {LOCATION_MZONE,0}
	range = range or rsef.GetRegisterRange(cardtbl) 
	local e1=rsef.FV(cardtbl,rscode.Utility_Xyz_Material,val,tg,tgrangetbl,range,con,resettbl,flag2,desctbl,ctlimittbl)
	return e1   
end

-------------------"Part_Effect_Activate"-------------------

--Activate Effect: Base set
function rsef.ACT(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,timingtbl,resettbl)
	local _,tc=rsef.GetRegisterCard(cardtbl)
	if tc:IsType(TYPE_TRAP+TYPE_QUICKPLAY) and not timingtbl then
		timingtbl={0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE }
	end
	if not desctbl then desctbl=rshint.act end
	if not code then code=EVENT_FREE_CHAIN end
	return rsef.Register(cardtbl,EFFECT_TYPE_ACTIVATE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end  
--Activate Effect: Equip Spell
function rsef.ACT_EQUIP(cardtbl,eqfilter,desctbl,ctlimittbl,con,cost) 
	if not desctbl then desctbl=rshint.eq end
	if not eqfilter then eqfilter=Card.IsFaceup end
	local eqfilter2=eqfilter
	eqfilter=function(c,e,tp)
		return c:IsFaceup() and eqfilter2(c,tp)
	end
	local e1=rsef.ACT(cardtbl,nil,desctbl,ctlimittbl,"eq","tg",con,cost,rstg.target({eqfilter,"eq",LOCATION_MZONE,LOCATION_MZONE,1}),rsef.ACT_EQUIP_op)
	local e2=rsef.SV(cardtbl,EFFECT_EQUIP_LIMIT,rsef.ACT_EQUIP_val(eqfilter),nil,nil,nil,"cd")
	return e1,e2
end
function rsef.ACT_EQUIP_op(e,tp,eg,ep,ev,re,r,rp) 
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if e:GetHandler():IsRelateToEffect(e) and tc then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function rsef.ACT_EQUIP_val(eqfilter) 
	return function(e,c)
		local tp=e:GetHandlerPlayer()
		return eqfilter(c,tp)
	end
end

-------------------"Part_Effect_SingleTigger"-------------------

--Self Tigger Effect No Force: Base set
function rsef.STO(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,nil,resettbl)
end 
--Self Tigger Effect Force: Base set
function rsef.STF(cardtbl,code,desctbl,ctlimittbl,cate,flag,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE,code,desctbl,ctlimittbl,cate,flag,nil,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect No Force: Base set
function rsef.FTO(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end
--Field Tigger Effect Force: Base set
function rsef.FTF(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end

---------------------"Part_Effect_Ignition"---------------------

--Ignition Effect: Base set
function rsef.I(cardtbl,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_IGNITION,nil,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end

----------------------"Part_Effect_Qucik"-----------------------

--Quick Effect No Force: Base set
function rsef.QO(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,timingtbl,resettbl)
	if not code then code=EVENT_FREE_CHAIN end
	if not timingtbl and code==EVENT_FREE_CHAIN then timingtbl={0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE } end
	return rsef.Register(cardtbl,EFFECT_TYPE_QUICK_O,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,timingtbl,resettbl)
end 
--Quick Effect: negate effect/activation/summon/spsummon
function rsef.QO_NEGATE(cardtbl,negtype,ctlimittbl,waystring,range,con,cost,desctbl,cate,flag,resettbl)
	local waylist={"des","rm","th","td","tg","set","nil"}
	local catelist={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,CATEGORY_TOGRAVE,0,0}
	local cate2=rsef.GetRegisterCategory(cate)
	local _,_,cate3=rsof.Table_Suit(waystring,waylist,catelist)
	if cate3 and cate3>0 then
		cate2=cate2|cate3
	end
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	if not negtype then negtype="neg" end
	if negtype=="dis" or nettype=="effect" then
		if not desctbl then desctbl=rshint.diseffect end
		local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP  
		cate2=cate2|CATEGORY_DISABLE 
		if not con then con=rscon.negcon(0) end 
		return rsef.QO(cardtbl,EVENT_CHAINING,desctbl,ctlimittbl,cate2,flag2,range,con,cost,rstg.distg(waystring),rsop.disop(waystring),nil,resettbl)   
	elseif negtype=="neg" or nettype=="act" then
		if not desctbl then desctbl=rshint.negeffect end
		local flag2=rsef.GetRegisterProperty(flag)|EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP  
		cate2=cate2|CATEGORY_NEGATE  
		if not con then con=rscon.discon(0) end
		return rsef.QO(cardtbl,EVENT_CHAINING,desctbl,ctlimittbl,cate2,flag2,range,con,cost,rstg.negtg(waystring),rsop.negop(waystring),nil,resettbl)  
	elseif negtype=="sum" then
		if not desctbl then desctbl=rshint.negsum end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		return rsef.QO(cardtbl,EVENT_SUMMON,desctbl,ctlimittbl,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,resettbl)  
	elseif negtype=="sp" then
		if not desctbl then desctbl=rshint.negsp end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		return rsef.QO(cardtbl,EVENT_SPSUMMON,desctbl,ctlimittbl,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,resettbl) 
	elseif negtype=="sum,sp" then
		if not desctbl then desctbl=rshint.negsum end
		cate2=cate2|CATEGORY_DISABLE_SUMMON  
		local e1=rsef.QO(cardtbl,EVENT_SUMMON,desctbl,ctlimittbl,cate2,flag2,range,con,cost,rstg.negsumtg(waystring),rsop.negsumop(waystring),nil,resettbl)  
		local e2=rsef.RegisterClone(cardtbl,e1,"code",EVENT_SPSUMMON)
		return e1,e2
	end
end 
--Quick Effect Force: Base set
function rsef.QF(cardtbl,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_QUICK_F,code,desctbl,ctlimittbl,cate,flag,range,con,cost,tg,op,nil,nil,nil,resettbl)
end

-----------------"Part_Effect_FieldContinues"-----------------

--Field Continues: Base set
function rsef.FC(cardtbl,code,desctbl,ctlimittbl,flag,range,con,op,resettbl)
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	return rsef.Register(cardtbl,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,code,desctbl,ctlimittbl,nil,flag,range,con,nil,nil,op,nil,nil,nil,resettbl)
end 
--Field Continues: Attach an extra effect when base effect is activating
function rsef.FC_AttachEffect_Activate(cardtbl,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force)
	return rsef.FC_AttachEffect(cardtbl,0x1,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force) 
end
--Field Continues: Attach an extra effect before the base effect solving
function rsef.FC_AttachEffect_BeforeResolve(cardtbl,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force)
	return rsef.FC_AttachEffect(cardtbl,0x2,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force) 
end
--Field Continues: Attach an extra effect after the base effect solving
function rsef.FC_AttachEffect_Resolve(cardtbl,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force)
	return rsef.FC_AttachEffect(cardtbl,0x4,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force)
end
--Field Continues: base set
--for old version see code 10199981
function rsef.FC_AttachEffect(cardtbl,attachtime,desctbl1,ctlimittbl,flag,range,attachcon,attachop,resettbl,force) 
	if not range then range=rsef.GetRegisterRange(cardtbl) end
	local c1,var2=rsef.GetRegisterCard(cardtbl)
	local flag2=rsflag.GetRegisterProperty({flag,"ptg"})
	local code=not force and rscode.Extra_Effect or rscode.Extra_Effect_FORCE
	local e1=rsef.FV(cardtbl,code,attachcon,nil,{1,0},range,rsef.FC_AttachEffect_setcon,resettbl,flag2,desctbl1) 
	e1:SetOperation(attachop) 
	e1:SetCategory(attachtime)
	local e2=rsef.I(cardtbl,nil,ctlimittbl,nil,nil,range,aux.FALSE,nil,nil,nil,resettbl)
	e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	if flag2&EFFECT_FLAG_NO_TURN_RESET~=0 then
		e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	end
	rsef.attachinfo[e1]=e2
	local reset,resetct=0,0
	if resettbl then 
		reset,resetct=rsef.RegisterReset(nil,resettbl,true) 
	end
	local desc=not desctbl1 and 0 or rsef.RegisterDescription(nil,desctbl1,true)
	if aux.GetValueType(var2)=="Card" then
		var2:RegisterFlagEffect(code,reset,EFFECT_FLAG_CLIENT_HINT,resetct,e1:GetFieldID(),desc)
	end
	if not rsef.FC_AttachEffect_Switch then
		rsef.FC_AttachEffect_Switch=true
		for i=0,1 do
			local e3=Effect.GlobalEffect()
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVING)
			e3:SetCondition(rsef.FC_AttachEffect_changecon)
			e3:SetOperation(rsef.FC_AttachEffect_changeop)
			e3:SetOwnerPlayer(i)
			Duel.RegisterEffect(e3,i)
		end
		--reset chain op information
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(rsef.FC_AttachEffect_resetinfo)
		e4:SetOwnerPlayer(i)
		Duel.RegisterEffect(e4,0)
		rsef.ChangeChainOperation=Duel.ChangeChainOperation
		Duel.ChangeChainOperation=rsef.ChangeChainOperation2
	end
	return e1,e2
end
function rsef.FC_AttachEffect_resetinfo(e,tp,eg,ep,ev,re,r,rp)
	local baseop=re:GetOperation()
	if not baseop then 
		baseop=function(e2) 
			return 
		end
	end 
	rsef.attachinfo[ev]=baseop
end
function rsef.ChangeChainOperation2(chainev,changeop,ischange)
	rsef.ChangeChainOperation(chainev,changeop)
	if not ischange then
		rsef.attachinfo[chainev]=changeop
	end
end
function rsef.GetOperation(e,chainev)
	return rsef.attachinfo[chainev]
end
function rsef.FC_AttachEffect_setcon(e)
	local tp=e:GetHandlerPlayer()
	local te=rsef.attachinfo[e]
	te:SetCondition(aux.TRUE)
	local bool=te:IsActivatable(tp)
	te:SetCondition(aux.FALSE)
	return bool 
end
function rsef.FC_AttachEffect_changecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,rscode.Extra_Effect) or Duel.IsPlayerAffectedByEffect(tp,rscode.Extra_Effect_FORCE)
end
function rsef.FC_AttachEffect_changeop(e,tp,eg,ep,ev,re,r,rp)
	local parameterlistcheck={e,tp,eg,ep,ev,re,r,rp}
	local attachlist=rsef.FC_AttachEffect_geteffect(parameterlistcheck,{},0x1,{})
	local baseop=rsef.GetOperation(re,ev)
	Duel.ChangeChainOperation(ev,rsef.FC_AttachEffect_changeop2(parameterlistcheck,baseop,attachlist),true)
end
function rsef.FC_AttachEffect_changeop2(parameterlistcheck,baseop,attachlist)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS) or c:IsLocation(LOCATION_PZONE)) and not c:IsRelateToEffect(e) then
			return
		end
		local attachlisttotal={}
		local parameterlistsolve={e,tp,eg,ep,ev,re,r,rp}
		--before base effect solve
		rsef.FC_AttachEffect_geteffect(parameterlistcheck,parameterlistsolve,0x2,attachlisttotal)
		--base effect
		--Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		baseop(e,tp,eg,ep,ev,re,r,rp)
		table.insert(attachlisttotal,baseop)
		--attachlist 
		for _,attacheffect in pairs(attachlist) do 
			table.insert(attachlisttotal,attacheffect)  
			rsef.FC_AttachEffect_Operation_Solve(parameterlistsolve,attacheffect,attachlisttotal)
		end
		--after base effect solve
		rsef.FC_AttachEffect_geteffect(parameterlistcheck,parameterlistsolve,0x4,attachlisttotal)
	end
end
function rsef.FC_AttachEffect_getgroup(parameterlistcheck,cardlist,attachtime)
	local e,tp,eg,ep,ev,re,r,rp=table.unpack(parameterlistcheck)
	local effectlist={Duel.IsPlayerAffectedByEffect(tp,rscode.Extra_Effect)}
	local g=Group.CreateGroup()
	for _,effect in pairs(effectlist) do
		local con=effect:GetValue()
		local cate=effect:GetCategory() 
		if (not con or con(effect,tp,eg,ep,ev,re,r,rp)) and effect:GetHandlerPlayer()==e:GetOwnerPlayer() and cate==attachtime then
			local tc=effect:GetHandler()
			if not cardlist[tc] then
				cardlist[tc]={}
			end
			table.insert(cardlist[tc],effect)
			g:AddCard(tc)
		end
	end
	return g
end
function rsef.FC_AttachEffect_geteffect(parameterlistcheck,parameterlistsolve,attachtime,attachlisttotal)
	local cardlist={}
	local attachlist={}
	local e,tp,eg,ep,ev,re,r,rp=table.unpack(parameterlistcheck)
	--get force effect 
	local effectlist={Duel.IsPlayerAffectedByEffect(tp,rscode.Extra_Effect_FORCE)}
	if #effectlist>0 then
		for _,effect in pairs(effectlist) do
			local con=effect:GetValue()
			local cate=effect:GetCategory() 
			if (not con or con(effect,tp,eg,ep,ev,re,r,rp)) and effect:GetHandlerPlayer()==e:GetOwnerPlayer() and cate==attachtime then
				local tc=effect:GetHandler()
				if tc:IsOnField() then
					Duel.HintSelection(rsgf.Mix2(tc))
				else 
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				end
				Duel.Hint(HINT_OPSELECTED,1-tp,effect:GetDescription())
				if attachtime~=0x1 then 
					table.insert(attachlisttotal,effect)
					rsef.FC_AttachEffect_Operation_Solve(parameterlistsolve,effect,attachlisttotal)
				end
				table.insert(attachlist,effect)
				local te=rsef.attachinfo[effect]
				te:UseCountLimit(tp,1)
			end
		end
	end
	--get not force
	local g=rsef.FC_AttachEffect_getgroup(parameterlistcheck,cardlist,attachtime)
	if #g<=0 then return attachlist end
	local hint=aux.Stringid(m,8)
	if attachtime==0x2 then hint=aux.Stringid(m,9) end
	if attachtime==0x4 then hint=aux.Stringid(m,10) end
	if not Duel.SelectYesNo(tp,hint) then return attachlist end
	local ct=1
	repeat
		ct=ct+1
		cardlist={}
		local g=rsef.FC_AttachEffect_getgroup(parameterlistcheck,cardlist,attachtime)
		if #g<=0 then break end
		rshint.Select(tp,HINTMSG_TARGET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsOnField() then
			Duel.HintSelection(rsgf.Mix2(tc))
		else 
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		end
		local effectlist2=cardlist[tc]
		local hintlist={}
		for _,effect in pairs(effectlist2) do
			local hint=effect:GetDescription()
			table.insert(hintlist,hint)
		end
		local op=Duel.SelectOption(tp,table.unpack(hintlist))+1
		local effect=effectlist2[op]
		--Duel.Hint(HINT_OPSELECTED,1-tp,effect:GetDescription())
		if attachtime~=0x1 then 
			table.insert(attachlisttotal,effect)
			rsef.FC_AttachEffect_Operation_Solve(parameterlistsolve,effect,attachlisttotal)
		end
		table.insert(attachlist,effect)
		local te=rsef.attachinfo[effect]
		te:UseCountLimit(tp,1)
		local g2=rsef.FC_AttachEffect_getgroup(parameterlistcheck,cardlist,attachtime)
	until (ct>1 and #g2<=0) or (ct>1 and not Duel.SelectYesNo(tp,aux.Stringid(m,11))) 
	return attachlist
end
function rsef.FC_AttachEffect_Operation_Solve(parameterlistsolve,currenteffect,attachlisttotal)
	--local e=table.unpack(parameterlistsolve)
	if aux.GetValueType(currenteffect)~="Effect" then 
		--Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
		currenteffect(table.unpack(parameterlistsolve)) 
	else
		--Duel.Hint(HINT_CARD,0,currenteffect:GetHandler():GetOriginalCode())
		local operation=currenteffect:GetOperation()
		operation(table.unpack(parameterlistsolve)) 
	end
	if rsef.FC_AttachEffect_Repeat then
		rsef.FC_AttachEffect_Repeat=false
		for index,attacheffect in pairs(attachlisttotal) do
			local _,indexrepeat=rsof.Table_List(attachlisttotal,currenteffect)
			if index>=indexrepeat then break end
			rsef.FC_AttachEffect_Operation_Solve(parameterlistsolve,attacheffect,attachlisttotal)
		end
	end
end

----------------"Part_Effect_SingleContinuous"----------------

--Single Continues: Base set
function rsef.SC(cardtbl,code,desctbl,ctlimittbl,flag,con,op,resettbl)
	return rsef.Register(cardtbl,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,code,desctbl,ctlimittbl,nil,flag,nil,con,nil,nil,op,nil,nil,nil,resettbl)
end 


-------------------"Part_Summon_Function"---------------------

--Summon Function: Quick Special Summon buff
--valtbl:{atk,def,lv} 
--waytbl:{way,resettbl} 
function rssf.SummonBuff(valtbl,dis,trigger,leaveloc,waytbl)
	return function(c,sc,e,tp,sg)
		local reset=((c==sc and not sg or #sg==1) and  rsreset.est_d or rsreset.est)
		if valtbl then
			local atk,def,lv=valtbl[1],valtbl[2],valtbl[3]
			rsef.SV_SET({c,sc,true},"atk,def",{atk,def},nil,reset)
			rsef.SV_CHANGE({c,sc,true},"lv",lv,nil,reset)
		end
		if dis then
			rsef.SV_LIMIT({c,sc,true},"dis,dise",nil,nil,reset)
		end
		if trigger then
			rsef.SV_LIMIT({c,tc,true},"tri",nil,nil,reset)
		end
		if type(leaveloc)=="number" then
			local flag=nil
			if c==sc then flag=EFFECT_CANNOT_DISABLE end
			rsef.SV_REDIRECT({c,sc,true},"leave",leaveloc,nil,rsreset.ered,flag)
		end
		if waytbl then
			if type(waytbl)=="string" then waytbl={waytbl} end
			if type(waytbl)=="boolean" then waytbl={"des"} end
			local way=waytbl[1]
			local resettbl=waytbl[2]
			if not resettbl then resettbl={0,1} end
			local reset2,resetct,resetplayer=resettbl[1],resettbl[2],resettbl[3]
			local fid=c:GetFieldID()
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(rscode.Summon_Flag,rsreset.est+reset2,0,resetct,fid)
			end  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END) 
			e1:SetCountLimit(1)
			if reset2 and reset2~=0 then
				e1:SetReset(reset2,resetct)
			end
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			sg:KeepAlive()
			e1:SetLabelObject(sg)
			e1:SetCondition(rssf.SummonBuff_Con(fid,resetct,resetplayer))
			e1:SetOperation(rssf.SummonBuff_Op(fid,way))
			Duel.RegisterEffect(e1,tp)   
		end
	end
end
function rssf.SummonBuff_Filter(c,e,fid)
	return c:GetFlagEffectLabel(rscode.Summon_Flag)==fid
end 
function rssf.SummonBuff_Con(fid,resetct,resetplayer)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SummonBuff_Filter,nil,e,fid)
		if rg:GetCount()<=0 then 
			g:DeleteGroup() e:Reset() 
		return false 
		end
		if resetplayer and resetplayer~=Duel.GetTurnPlayer() then return false 
		end
		local tid1=rg:GetFirst():GetTurnID()
		local tid2=Duel.GetTurnCount()
		if resetct==0 and tid1~=tid2 then return false end
		if resetct>1 and tid1==tid2 then return false end
		return true
	end
end
function rssf.SummonBuff_Op(fid,way)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetOwner()
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		local g=e:GetLabelObject()
		local rg=g:Filter(rssf.SummonBuff_Filter,nil,e,fid)
		if way=="des" then Duel.Destroy(rg,REASON_EFFECT)
		elseif way=="th" then Duel.SendtoHand(rg,nil,REASON_EFFECT)
		elseif way=="td" then Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		elseif way=="tdt" then Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
		elseif way=="tdb" then Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
		elseif way=="rm" then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		elseif way=="rg" then Duel.SendtoGrave(rg,REASON_EFFECT)
		end
		if g:FilterCount(rssf.SummonBuff_Filter,nil,e,fid)<=0 then
			g:DeleteGroup()
			e:Reset()
		end
	end
end 
--Summon Function: Duel.SpecialSummon + buff
function rssf.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumfun)
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local ct=0
	if zone then
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		ct=Duel.SpecialSummon(ssgorc,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	local g=Duel.GetOperatedGroup()
	if #g>0 and sumfun then
		local c=g:GetFirst():GetReasonEffect():GetHandler()
		for tc in aux.Next(g) do
			sumfun(c,tc,e,tp,g)
		end
	end 
	return ct,g 
end 
--Summon Function: Duel.SpecialSummonStep + buff 
function rssf.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone,sumfun) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	local tf=false
	if zone then
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone)
	else
		tf=Duel.SpecialSummonStep(sscard,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	end
	if tf and sumfun then
		local c=sscard:GetReasonEffect():GetHandler()
		sumfun(c,sscard,e,tp)
	end
	return tf,sscard
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEither(ssgorc,e,sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos,zone2,sumfun) 
	sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos=rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	local tp=ssplayer
	local zone={}
	local flag={}
	if not zone2 then
		zone2={[0]=0x1f,[1]=0x1f}
	end
	local ssg=rsgf.Mix2(ssgorc)
	for sscard in aux.Next(ssg) do 
		local ava_zone=0
		for p=0,1 do
			zone[p]=zone2[p]&0xff
			local _,flag_tmp=Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[p])
			flag[p]=(~flag_tmp)&0x7f
		end
		for p=0,1 do
			if sscard:IsCanBeSpecialSummoned(e,sstype,ssplayer,ignorecon,ignorerevie,pos,p,zone[p]) then
				ava_zone=ava_zone|(flag[p]<<(p==tp and 0 or 16))
			end
		end
		if ava_zone<=0 then return 0,nil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00ff00ff&(~ava_zone))
		local sump=0
		if sel_zone&0xff>0 then
			sump=tp
		else
			sump=1-tp
			sel_zone=sel_zone>>16
		end
		if rssf.SpecialSummonStep(sscard,sstype,ssplayer,sump,ignorecon,ignorerevie,pos,sel_zone,sumfun) then
			ssg:AddCard(sscard)
		end
	end
	if #ssg>0 then
		Duel.SpecialSummonComplete()
	end
	return #ssg,ssg 
end
--Summon Function: Set Default Parameter
function rssf.GetSSDefaultParameter(sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos)
	if not sstype then sstype=0 end
	if not ssplayer then ssplayer=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER) end
	if not tplayer then tplayer=ssplayer end
	if not ignorecon then ignorecon=false end
	if not ignorerevie then ignorerevie=false end
	if not pos then pos=POS_FACEUP end
	return sstype,ssplayer,tplayer,ignorecon,ignorerevie,pos
end

-------------------"Part_Value_Function"---------------------

--value: SF_SSConditionValue - can only be special summoned from Extra Deck (if can only be XXX summoned from Extra Deck, must use aux.OR(xxxval,rsval.spconfe), but not AND)
function rsval.spconfe(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--value: SummonConditionValue - can only be special summoned by self effects
function rsval.spcons(e,se,sp,st)
	return se:GetHandler()==e:GetHandler() and se:IsHasType(EFFECT_TYPE_ACTIONS) 
end
--value: reason by battle or card effects
function rsval.indbae(string1,string2)
	return function(e,re,r,rp)
		if not string1 and not string2 then return r&REASON_BATTLE+REASON_EFFECT ~=0 end
		return ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 )
	end
end
--value: reason by battle or card effects, EFFECT_INDESTRUCTABLE_COUNT
function rsval.indct(string1,string2)
	return function(e,re,r,rp)
		if ((string1=="battle" or string2=="battle") and r&REASON_BATTLE ~=0 ) or ((string1=="effect" or string2=="effect") and r&REASON_EFFECT ~=0 ) or (not string1 and not string2 and r&REASON_BATTLE+REASON_EFFECT ~=0) then
			return 1
		else return 0 
		end
	end
end
--value: unaffected by opponent's card effects
function rsval.imoe(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--value: unaffected by other card effects 
function rsval.imes(e,re)
	return re:GetOwner()~=e:GetOwner()
end
--value: unaffected by other card effects that do not target it
function rsval.imntg1(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetOwner()==e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: unaffected by opponent's card effects that do not target it
function rsval.imntg2(e,re)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: EFFECT_CANNOT_INACTIVATE,EFFECT_CANNOT_DISEFFECT
function rsval.cdisneg(filter)
	return function(e,ct)
		local p=e:GetHandlerPlayer()
		local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
		return (not filter and p==tp) or filter(e,p,te,tp,loc)
	end
end

-------------------"Part_Target_Function"---------------------

--Card target: do not have an effect target it
function rstg.neftg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end 
--Effect Target: Negative Effect/Activate
function rstg.disnegtg(disorneg,waystring)
	local dncate=0
	if disorneg=="dis" then dncate=CATEGORY_DISABLE 
	elseif disorneg=="neg" then dncate=CATEGORY_NEGATE 
	elseif disorneg=="sum" then dncate=CATEGORY_DISABLE_SUMMON 
	end
	local setfun=function(setc,setignore)
		return setc:IsSSetable(true)
	end
	local waylist={"des","rm","th","td","tg","set","nil"}
	local waylist2={aux.TRUE,Card.IsAbleToRemove,Card.IsAbleToHand,Card.IsAbleToDeck,Card.IsAbleToGrave,setfun,aux.TRUE }
	local waylist3={Card.IsDestructable,Card.IsAbleToRemove,Card.IsAbleToHand,Card.IsAbleToDeck,Card.IsAbleToGrave,setfun,aux.TRUE }
	local catelist={CATEGORY_DESTROY,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,CATEGORY_TOGRAVE,0,0}
	if type(waystring)==nil then waystring="des" end
	if not waystring then waystring="nil" end
	local _,_,filterfun=rsof.Table_Suit(waystring,waylist,waylist2)
	local _,_,filterfun2,cate=rsof.Table_Suit(waystring,waylist,waylist3,catelist)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local rc=re:GetHandler()
		if chk==0 then return 
			--filterfun(rc) 
			waystring~="rm" or aux.nbcon(tp,re) 
		end
		Duel.SetOperationInfo(0,dncate,eg,1,0,0)
		if cate and cate~=0 then 
			if disorneg=="sum" or (filterfun2(rc) and rc:IsRelateToEffect(re)) then
				Duel.SetOperationInfo(0,cate,eg,1,0,0)
			end
		end
	end
end
function rstg.distg(waystring)
	return function(...)
		return rstg.disnegtg("dis",waystring)(...)
	end
end
function rstg.negtg(waystring)
	return function(...)
		return rstg.disnegtg("neg",waystring)(...)
	end
end
function rstg.negsumtg(waystring)
	return function(...)
		return rstg.disnegtg("sum",waystring)(...)
	end
end
--Target function: Get target attributes
function rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetlist)
	if not targetlist then return 0,0,0,0,nil end
	local ffunction=targetlist[1]
	if not ffunction then ffunction=aux.TRUE end
	local catevalue=targetlist[2]
	local catelist={}
	local catefun=nil
	local selecthint=nil
	if type(catevalue)=="function" then 
		catefun=catevalue
	elseif type(catevalue)=="string" then
		catelist=catevalue
	elseif type(catevalue)=="table" then
		if #catevalue==1 then
			if type(catevalue[1])=="function" then
				catefun=catevalue[1]
			else
				catelist=catevalue[1]
			end
		elseif #catevalue==2 then
			catelist=catevalue[1]
			catefun=catevalue[2]
		elseif #catevalue==3 then
			catelist=catevalue[1]
			catefun=catevalue[2]
			selecthint=catevalue[3]
		end
	end
	local _,catelist2,catestringlist=rsef.GetRegisterCategory(catelist)
	local loc1,loc2=targetlist[3],targetlist[4]
	if type(loc1)=="function" then
		loc1=loc1(e,tp,eg,ep,ev,re,r,rp)
	end
	if type(loc2)=="function" then
		loc2=loc2(e,tp,eg,ep,ev,re,r,rp)
	end
	local minct,maxct=targetlist[5],targetlist[6]
	if type(minct)=="nil" then minct=1 end
	if type(minct)=="function" then 
		minct=minct(e,tp,eg,ep,ev,re,r,rp) 
		if minct==0 then minct=999 end
	end
	if not maxct then maxct=minct end 
	if type(maxct)=="function" then maxct=maxct(e,tp,eg,ep,ev,re,r,rp) end
	local exceptfun=targetlist[7]
	local isoptional=targetlist[8]
	--local selecthint=targetlist[9]  
	local listtype=targetlist[10]
	if not listtype then
		listtype="target"
	end
	if not loc1 then loc1=true end
	if not loc2 then loc2=0 end 
	return ffunction,catelist2,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype
end
--Effect target: Target Cards Main Set 
--effect parameter table main set
function rsef.list(listtype,valuetype,...)
	local targetlist={}
	if type(valuetype)=="table" then 
		if type(valuetype[1])=="table" then 
			targetlist=valuetype
		else
			targetlist={valuetype,...}
		end
	else
		targetlist={{valuetype,...}}
	end  
	for _,listtypelist in pairs(targetlist) do
		if not listtypelist[10] then
			listtypelist[10]=listtype
		end
	end  
	return table.unpack(targetlist)
end
--cost parameter table
function rscost.list(valuetype,...)
	return rsef.list("cost",valuetype,...)
end
--target parameter table has card target 
function rstg.list(valuetype,...)
	return rsef.list("target",valuetype,...)
end
--operation check parameter table don't have card target
function rsop.list(valuetype,...)
	return rsef.list("operationcheck",valuetype,...)
end
--operation solve parameter table 
function rsop.list2(valuetype,...)
	return rsef.list("operationsolve",valuetype,...)
end
--operation solve parameter table , check following parameter
function rsop.list3(valuetype,...)
	return rsef.list("operationsolvecheckfollow",valuetype,...)
end
--targetvalue1={ffunction,category,loc1,loc2,minct,maxct,exceptfun,selecthint}
function rstg.target0(checkfun,targetfun,...)
	local targetlist={rstg.list(...)}
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc or chk==0 then 
			return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,targetlist) and (not checkfun or checkfun(e,tp,eg,ep,ev,re,r,rp))
		end
		local targetgroup=rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,targetlist)
		if targetfun then
			targetfun(targetgroup,e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function rstg.target(...)
	return rstg.target0(nil,nil,...)
end
function rstg.target2(targetfun,...)
	return rstg.target0(nil,targetfun,...)
end
function rstg.target3(checkfun,...)
	return rstg.target0(checkfun,nil,...)
end
--Effect target: check currnet targetlist type
function rstg.CheckTargetlistType(listtype)
	local b1= listtype=="cost"   --cost select
	local b2= listtype=="target" --target select
	local b3= listtype=="operationcheck" --or not e:IsHasProperty(EFFECT_FLAG_CARD_TARGET)  --operation select 
	local b4= listtype=="operationsolve"  --operation solve
	local b5= listtype=="operationsolvecheckfollow"  --operation solve, check if this solving will affect following solving (Traptrick)
	--local b6= listtype=="playertarget" -- for draw, damge, recover
	return b1,b2,b3,b4,b5
end
--Effect target: Get Check Fun 
function rstg.GetTargetCheckAndSelectFun(b2,catelist)
	local targetcheckfun= not b2 and Duel.IsExistingMatchingCard or Duel.IsExistingTarget 
	local targetselectfun= not b2 and Duel.SelectMatchingCard or Duel.SelectTarget 
	local playertargetlist={ CATEGORY_DRAW,CATEGORY_DECKDES,CATEGORY_RECOVER,CATEGORY_DAMAGE } --CATEGORY_HANDES
	for _,cate in pairs(playertargetlist) do
		if rsof.Table_List(catelist,cate) then
			targetcheckfun=rstg.Target_Fun_Check_Fun(cate)
			targetselectfun=rstg.Target_Fun_Select_Fun(cate)
		end
	end
	return targetcheckfun,targetselectfun
end
--Effect target: Check chkc & chk
function rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,valuetype,...)
	local targetlist={rstg.list(valuetype,...)}
	local c=e:GetHandler()
	local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetlist[1])
	local b1,b2,b3,b4,b5=rstg.CheckTargetlistType(listtype)
	local exceptg=rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
	if chkc then
		if type(loc1)=="boolean" then 
			return chkc==c and (not ffunction or ffunction(chkc,e,tp,eg,ep,ev,re,r,rp))
		end
		if #targetlist>1 then return false end
		if minct>1 then return false end
		if not chkc:IsLocation(loc1+loc2) then return false end 
		if loc1==0 and loc2>0 and chkc:IsControler(tp) then return false end
		if loc2==0 and loc1>0 and chkc:IsControler(1-tp) then return false end
		if #exceptg>0 and exceptg:IsContains(chkc) then return false end
		if ffunction and not ffunction(chkc,e,tp,eg,ep,ev,re,r,rp) then  return false end
		return true
	end 
	if chk==0 then 
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) then return true end
		local usingg=Group.CreateGroup()
		local usingct={[0]={},[1]={}}
		local targetfun=rstg.GetTargetCheckAndSelectFun(b2,catelist)
		--case self
		if type(loc1)=="boolean" then return
			not exceptg:IsContains(c) and rstg.TargetFilter(c,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,table.unpack(targetlist))
			--targetfun(rstg.TargetFilter,tp,c:GetLocation(),0,1,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,table.unpack(targetlist))
		--case normal
		else 
			local minct2=minct
			if type(minct)~="number" or minct==0 then
				minct2=1
			end
			if type(minct)=="number" and minct==999 then return false end 
			return targetfun(rstg.TargetFilter,tp,loc1,loc2,minct2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,table.unpack(targetlist))
		end
	end
end
function rstg.PlayerTarget_Set_Usingct(cate,tp,spct,opct,usingct)
	if spct>0 then
		usingct[tp][cate]=usingct[tp][cate] or 0
		local spct2=usingct[tp][cate]+spct 
		usingct[tp][cate]=spct2
		if cate==CATEGORY_DRAW and not Duel.IsPlayerCanDraw(tp,spct2) then return false end
		--if cate==CATEGORY_HANDES and not Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=spct2 then return false end
		if cate==CATEGORY_DECKDES and not Duel.IsPlayerCanDiscardDeck(tp,spct2) then return false end
	end
	if opct>0 then
		usingct[1-tp][cate]=usingct[1-tp][cate] or 0
		local opct2=usingct[1-tp][cate]+opct 
		usingct[1-tp][cate]=opct2
		if cate==CATEGORY_DRAW and not Duel.IsPlayerCanDraw(1-tp,opct2) then return false end
		--if cate==CATEGORY_HANDES and not Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=opct2 then return false end
		if cate==CATEGORY_DECKDES and not Duel.IsPlayerCanDiscardDeck(1-tp,opct2) then return false end
	end
	return true
end
function rstg.Target_Fun_Check_Fun(cate)
	return function(filter,tp,spct,opct,minct2_nouse,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue1,targetvalue2,...)
		if not rstg.PlayerTarget_Set_Usingct(cate,tp,spct,opct,usingct) then return false end
		if not targetvalue2 then return true end
		local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetvalue2)
		local b1,b2,b3,b4,b5=rstg.CheckTargetlistType(listtype)
		local targetfun=rstg.GetTargetCheckAndSelectFun(b2,catelist)
		local exceptg=rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
		return targetfun(rstg.TargetFilter,tp,loc1,loc2,minct2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue2,...)
	end
end
function rstg.Target_Fun_Select_Fun(cate)
	return function(selectp,filter_nouse,locp_nouse,spct,opct,minct_nouse,maxct_nouse,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue1,...)
		rstg.PlayerTarget_Set_Usingct(cate,tp,spct,opct,usingct)   
		return Group.CreateGroup(),{[tp]=spct,[1-tp]=opct}
	end
end
function rstg.Target_Fun_Check_NullFun(filter,tp,spct,opct,minct2_nouse,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue1,targetvalue2,...)
	if not targetvalue2 then return true end
	local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetvalue2)
	local b1,b2,b3,b4,b5=rstg.CheckTargetlistType(listtype)
	local targetfun=rstg.GetTargetCheckAndSelectFun(b2,catelist)
	local exceptg=rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
	return targetfun(rstg.TargetFilter,tp,loc1,loc2,minct2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue2,...)
end
--Effect target: Target filter 
function rstg.TargetFilter(c,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetvalue1,targetvalue2,...)
	local usingg2=usingg:Clone() 
	local usingct2=rsof.Table_Clone(usingct)
	usingg2:AddCard(c) 
	if targetvalue1 then
		local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetvalue1)
		if isoptional then ffunction=aux.TRUE end
		if ffunction and not ffunction(c,e,tp,eg,ep,ev,re,r,rp,usingg,usingct) then return false end
		--if type(loc1)~="number" and c~=e:GetHandler() then return false end
	end 
	if targetvalue2 then
		local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetvalue2)
		local b1,b2,b3,b4,b5=rstg.CheckTargetlistType(listtype)
		local targetfun=rstg.GetTargetCheckAndSelectFun(b2,catelist)
		local exceptg=rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
		exceptg:Merge(usingg2)
		if type(loc1)=="boolean" then 
			return not exceptg:IsContains(e:GetHandler()) and rstg.TargetFilter(e:GetHandler(),e,tp,eg,ep,ev,re,r,rp,usingg2,usingct2,targetvalue2,...)
			--return targetfun(rstg.TargetFilter,tp,c:GetLocation(),loc2,1,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg2,targetvalue2,...)  
		else 
			local minct2=minct
			if type(minct)~="number" or minct==0 then
				minct2=1
			end
			if type(minct)=="number" and minct==999 then return false end
			return targetfun(rstg.TargetFilter,tp,loc1,loc2,minct2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg2,usingct2,targetvalue2,...)
		end
	end
	return true
end
--Effect target: Select targets
function rstg.TargetSelectNoInfo(e,tp,eg,ep,ev,re,r,rp,valuetype,...)
	local chainid=Duel.GetCurrentChain()
	local targetlist={rstg.list(valuetype,...)}
	local c=e:GetHandler()
	local cateinfolist={}
	local costinfolist={}
	local costinfoindexlist={} --cost must apply in sequence,operation info mustn't
	local targettotalgroup=Group.CreateGroup()
	local costtotalgroup=Group.CreateGroup()
	local costrealgroup=Group.CreateGroup()
	local usingg=Group.CreateGroup()
	local usingct={[0]={},[1]={}}
	for i=1,#targetlist do
		local targetlistfollow={}
		for k,targetvalue in pairs(targetlist) do
			if k>i then table.insert(targetlistfollow,targetvalue) end
		end 
		local ffunction,catelist,catestringlist,catefun,selecthint,loc1,loc2,minct,maxct,exceptfun,isoptional,listtype = rstg.GetTargetAttribute(e,tp,eg,ep,ev,re,r,rp,targetlist[i])
		local selectgroup=nil
		local selectplayervalue={[tp]={},[1-tp]={}} --use for player target effects
		local b1,b2,b3,b4,b5=rstg.CheckTargetlistType(listtype)  
		local exceptg=rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
		exceptg:Merge(usingg)
		local limitgroup=Group.CreateGroup()
		if b1 or b2 or b4 then
			if rsof.Table_List(catelist,CATEGORY_RELEASE) then
				if type(loc1)=="boolean" then
					limitgroup=Group.FromCards(c)
				elseif type(loc1)=="number" then
					if loc1&LOCATION_MZONE ~=0 then
						local includehand= loc1&LOCATION_HAND ~=0 and true or false 
						local rg1=Duel.GetReleaseGroup(tp,includehand)
						limitgroup:Merge(rg1)
					end
					if loc2 and loc2&LOCATION_MZONE ~=0 then
						local rg2=Duel.GetReleaseGroup(1-tp)
						limitgroup:Merge(rg2)
					end 
					local rg3=Duel.GetMatchingGroup(rstg.TargetFilter,tp,loc1,loc2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
					limitgroup:Merge(rg3)
				end
			end
			local _,selectfun=rstg.GetTargetCheckAndSelectFun(b2,catelist)
			local hint=rsef.GetDefaultHintString(catelist,loc1,loc2,selecthint)
			Duel.Hint(HINT_SELECTMSG,tp,hint)
			if #limitgroup>0 then
				if type(loc1)=="boolean" then
					selectgroup=limitgroup:Filter(rstg.TargetFilter,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
				elseif type(loc1)=="number" then
					selectgroup=limitgroup:FilterSelect(tp,rstg.TargetFilter,minct,maxct,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
				end
				if b2 and #selectgroup>0 then  
					Duel.SetTargetCard(selectgroup)
				end
			else
				if type(loc1)=="boolean" then
					selectgroup=rsgf.Mix2(c):Filter(rstg.TargetFilter,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
					if b2 then
						if #selectgroup>0 then
							Duel.SetTargetCard(selectgroup)
						end
					end
				elseif type(loc1)=="number" then
					selectgroup,selectplayervalue=selectfun(tp,rstg.TargetFilter,tp,loc1,loc2,minct,maxct,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
				end
			end
		end
		-- black hole (no target but operationinfo need group)
		if (b1 or b3 or b4) and (type(maxct)~="number" or maxct==0) then
			selectgroup=Duel.GetMatchingGroup(rstg.TargetFilter,tp,loc1,loc2,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,targetlist[i],table.unpack(targetlistfollow))
		end
		--target 
		if b4 and type(loc1)=="table" then
			local solvelist=rsef.targetlist[chainid]
			local solvegroup=Group.CreateGroup()
			for _,listindex in pairs(loc1) do
				if listindex==0 then
					solvegroup=rsgf.GetTargetGroup()
				else
					if solvelist[listindex] then
						solvegroup:Merge(rsgf.Table_To_Group(solvelist[listindex]))
					end
				end
			end
			selectgroup=solvegroup:Filter(rstg.targetsolvefilter,exceptg,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,ffunction)
		end
		--operation info catelist 
		local playertargetcatelist={ CATEGORY_DRAW,CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES } --CATEGORY_HANDES 
		for _,cate in ipairs(catelist) do 
			local selectinfolist=b1 and costinfolist or cateinfolist
			--because player use 0 and 1 , some caculate like 0+1=1 ,cannot get PLAYER_ALL(3) ,so first treat base player as 1 and 2
			local playerlist={[0]=1,[1]=2}
			if not selectinfolist[cate] then
				if rsof.Table_List(playertargetcatelist,cate) then
					selectinfolist[cate]={nil,0,0,{[0]=0,[1]=0}}
				else
					selectinfolist[cate]={Group.CreateGroup(),0,0,0}
				end
				if b1 and not rsof.Table_List(costinfoindexlist,cate) then
					table.insert(costinfoindexlist,cate)
				end
			end
			local infog,infoct,infop,infoloc=selectinfolist[cate][1],selectinfolist[cate][2],selectinfolist[cate][3],selectinfolist[cate][4]
			if selectgroup and infog then
				infog:Merge(selectgroup)
				infoct=infoct+#selectgroup
			else
				infoct=infoct+minct
			end
			--case normal operationinfo 
			if not rsof.Table_List(playertargetcatelist,cate) then
				if type(loc1)=="number" and loc1>0 then 
					infop=infop|playerlist[tp]
					infoloc=infoloc|loc1
				end
				if type(loc2)=="number" and loc2>0 then
					infop=infop|playerlist[1-tp]
					infoloc=infoloc|loc2
				end
			else
				if type(loc1)=="number" and loc1>0 then
					infop=infop|playerlist[tp]
					infoloc[tp]=infoloc[tp]+loc1
				end
				if type(loc2)=="number" and loc2>0 then
					infop=infop|playerlist[1-tp]
					infoloc[1-tp]=infoloc[1-tp]+loc2
				end
			end
			selectinfolist[cate]={infog,infoct,infop,infoloc}
		end
		if selectgroup then
			usingg:Merge(selectgroup)
			exceptg:Merge(usingg)  
			if b1 or b4 then
				costtotalgroup:Merge(selectgroup)
				if b4 then
					local hintselectg=selectgroup:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE)
					if #hintselectg>0 and type(loc1)~="table" then
						Duel.HintSelection(hintselectg)
					end
				end
				local costres=rscost.CostSolve(#selectgroup==0 and selectplayervalue or selectgroup,catestringlist,catefun,b4,e,tp,eg,ep,ev,re,r,rp,usingg,usingct)
				if not costres or (aux.GetValueType(costres)=="Group" and #costres<=0) then return end
			elseif b2 or b3 then
				if b2 then
					if not rsef.targetlist[chainid] then
						rsef.targetlist[chainid]={}
					end
					table.insert(rsef.targetlist[chainid],rsgf.Group_To_Table(selectgroup))
				end
				targettotalgroup:Merge(selectgroup)
			end
		end
	end
	return targettotalgroup,cateinfolist,costtotalgroup,costrealgroup,costinfolist,costinfoindexlist
end
function rstg.targetsolvefilter(c,e,tp,eg,ep,ev,re,r,rp,usingg,usingct,ffunction)
	return c:IsRelateToEffect(e) and ffunction(c,e,tp,eg,ep,ev,re,r,rp,usingg,usingct)
end
function rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,valuetype,...)
	local targettotalgroup,cateinfolist=rstg.TargetSelectNoInfo(e,tp,eg,ep,ev,re,r,rp,valuetype,...)
	for _,cate in ipairs(rscate.catelist) do 
		if cateinfolist[cate] then 
			local infog,infoct,infop,infoloc=cateinfolist[cate][1],cateinfolist[cate][2],cateinfolist[cate][3],cateinfolist[cate][4]
			--because player use 0 and 1 , some caculate like 0+1=1 ,cannot get PLAYER_ALL(3) ,so first treat base player as 1 and 2, inverse operation
			local playerlist={[0]=0,[1]=0,[2]=1,[3]=3} 
			infop=playerlist[infop]
			local playertargetcatelist={ CATEGORY_DRAW,CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES } --CATEGORY_HANDES
			if rsof.Table_List(playertargetcatelist,cate) then 
				local spvalue=infoloc[tp]
				local opvalue=infoloc[1-tp]
				local infovalue=0
				if spvalue>0 and opvalue>0 then infovalue=math.min(spvalue,opvalue) 
				else 
					infovalue=spvalue>0 and spvalue or opvalue 
					if e:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) then
						Duel.SetTargetPlayer(spvalue>0 and tp or 1-tp)
						Duel.SetTargetParam(infovalue)
					end
				end
				Duel.SetOperationInfo(0,cate,nil,0,infop,infovalue)
			else
				Duel.SetOperationInfo(0,cate,infog,infoct,infop,infoloc)
			end
		end
	end
	return targettotalgroup
end
--Target: cost influence effect (rscost.reglabel)
function rstg.reglabel(nolabeltg,inlabeltg,labelct)
	labelct=labelct or 100
	nolabeltg=nolabeltg or aux.FALSE 
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then
			if e:GetLabel()~=labelct then
				return nolabeltg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
			else
				e:SetLabel(0)
				return inlabeltg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
			end
		end
		if chk==0 then
			if e:GetLabel()~=labelct then
				return nolabeltg(e,tp,eg,ep,ev,re,r,rp,0)
			else
				return inlabeltg(e,tp,eg,ep,ev,re,r,rp,0)
			end
		end
		e:SetLabel(0)
		if e:GetLabel()~=labelct then
			nolabeltg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			inlabeltg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end

-------------------"Part_Cost_Function"---------------------

--cost: togarve/remove/discard/release/tohand/todeck as cost
function rscost.cost0(checkfun,costfun,...)
	local costlist={rscost.list(...)}
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then 
			return rscost.CostCheck(e,tp,eg,ep,ev,re,r,rp,chk,costlist) and (not checkfun or checkfun(e,tp,eg,ep,ev,re,r,rp))
		end
		rscost.CostSelect(e,tp,eg,ep,ev,re,r,rp,costfun,costlist)
	end
end
function rscost.cost(...)
	return rscost.cost0(nil,nil,...)
end
function rscost.cost2(costfun,...)
	return rscost.cost0(nil,costfun,...)
end
function rscost.cost3(checkfun,...)
	return rscost.cost0(checkfun,nil,...) 
end
--cost check
function rscost.CostCheck(e,tp,eg,ep,ev,re,r,rp,chk,costlist)
	return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,nil,costlist)
end
--cost select
function rscost.CostSelect(e,tp,eg,ep,ev,re,r,rp,costfun,costlist)
	local _,_,costtotalgroup,costrealgroup,costinfolist,costinfoindexlist = rstg.TargetSelectNoInfo(e,tp,eg,ep,ev,re,r,rp,costlist)
	if costfun then costfun(costrealgroup,e,tp,eg,ep,ev,re,r,rp) end 
	return costtotalgroup,costrealgroup
end
--cost solve
function rscost.CostSolve(costgroup_or_playervalue,catestringlist,catefun,isoperation,e,tp,eg,ep,ev,re,r,rp,usingg,usingct)
	local costrealct=0 
	local costrealgroup=nil
	if catefun then
		local value=catefun(costgroup_or_playervalue,e,tp,eg,ep,ev,re,r,rp,usingg,usingct)
		if aux.GetValueType(value)=="Card" or aux.GetValueType(value)=="Group" then
			costrealgroup=rsgf.Mix2(value)
		else
			costrealgroup=Duel.GetOperatedGroup()
		end
		return costrealgroup,#costrealgroup
	end
	if not catestringlist or #catestringlist==0 then return true end
	local reason=not isoperation and REASON_COST or REASON_EFFECT 
	return rsop.operationcard(costgroup_or_playervalue,catestringlist[1],reason,e,tp,eg,ep,ev,re,r,rp)
end
--operation/cost function: do operation in card/group
function rsop.operationcard(corg_or_pv,waystring,reason,e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if type(corg_or_pv)=="table" then 
		local spct=corg_or_pv[tp]
		local opct=corg_or_pv[1-tp]
		if waystring=="dr" then
			if spct>0 then ct=ct+Duel.Draw(tp,spct,reason) end
			if opct>0 then ct=ct+Duel.Draw(1-tp,opct,reason) end
		elseif waystring=="rec" then
			if spct>0 then ct=ct+Duel.Recover(tp,spct,reason,true) end
			if opct>0 then ct=ct+Duel.Recover(1-tp,opct,reason,true) end
			Duel.RDComplete()
		elseif waystring=="dam" then
			if spct>0 then ct=ct+Duel.Damage(tp,spct,reason,true) end
			if opct>0 then ct=ct+Duel.Damage(1-tp,opct,reason,true) end
			Duel.RDComplete()
		elseif waystring=="disd" then
			if spct>0 then ct=ct+Duel.DiscardDeck(tp,spct,reason) end
			if opct>0 then ct=ct+Duel.DiscardDeck(-tp,opct,reason) end
		end
		return ct>0,ct
	end
	if waystring=="des" then ct=Duel.Destroy(corg_or_pv,reason)
	elseif waystring=="des_rm" then ct=Duel.Destroy(corg_or_pv,reason,LOCATION_REMOVED)
	elseif waystring=="rm" then ct=Duel.Remove(corg_or_pv,POS_FACEUP,reason)
	elseif waystring=="rm_d" then ct=Duel.Remove(corg_or_pv,POS_FACEDOWN,reason)
	elseif waystring=="th" then 
		ct=Duel.SendtoHand(corg_or_pv,nil,reason)
		if ct>0 and (corg_or_pv:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) or corg_or_pv:IsExists(Card.IsPreviousPosition,1,nil,POS_FACEDOWN)) then
			Duel.ConfirmCards(1-tp,corg_or_pv)
		end
	elseif waystring=="td" or waystring=="te" then ct=Duel.SendtoDeck(corg_or_pv,nil,2,reason)
	elseif waystring=="te_u" then ct=Duel.SendtoExtraP(corg_or_pv,nil,reason)
	elseif waystring=="td_t" then ct=Duel.SendtoDeck(corg_or_pv,nil,0,reason)
	elseif waystring=="td_b" then ct=Duel.SendtoDeck(corg_or_pv,nil,1,reason)
	elseif waystring=="tg" then 
		reason=corg_or_pv:GetFirst():IsLocation(LOCATION_REMOVED) and reason|REASON_RETURN or reason
		ct=Duel.SendtoGrave(corg_or_pv,reason)
	elseif waystring=="tg_r" then 
		ct=Duel.SendtoGrave(corg_or_pv,reason|REASON_RETURN)
	elseif waystring=="dish" then
		ct=Duel.SendtoGrave(corg_or_pv,reason|REASON_DISCARD)
	elseif waystring=="res" then
		ct=Duel.Release(corg_or_pv,reason)
	elseif waystring=="con" then
		if Duel.GetControl(corg_or_pv,tp) then
			 ct=Duel.GetOperatedGroup():GetCount()
		end
	elseif waystring=="con_ep" then
		if Duel.GetControl(corg_or_pv,tp,PHASE_END,1) then
			 ct=Duel.GetOperatedGroup():GetCount()
		end
	elseif waystring=="pos" then ct=Duel.ChangePosition(corg_or_pv,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	elseif waystring=="pos_a" then ct=Duel.ChangePosition(corg_or_pv,POS_FACEUP_ATTACK)
	elseif waystring=="pos_d" then ct=Duel.ChangePosition(corg_or_pv,POS_FACEUP_DEFENSE)
	elseif waystring=="pos_dd" then ct=Duel.ChangePosition(corg_or_pv,POS_FACEDOWN_DEFENSE)
	elseif waystring=="set" then
		local stsetfun=function(stc)
			return (stc:IsStatus(STATUS_LEAVE_CONFIRMED) or stc:IsStatus(STATUS_ACTIVATE_DISABLED)) and stc:IsSSetable(true) 
		end
		local stg=corg_or_pv:Filter(stsetfun,nil)
		if #stg>0 then
			for tc in aux.Next(stg) do
				tc:CancelToGrave(true)
			end
			ct=Duel.ChangePosition(corg_or_pv,POS_FACEDOWN_DEFENSE)
			stg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
			if ct>0 and #stg>0 then
				Duel.RaiseEvent(stg,EVENT_SSET,e,reason,tp,tp,0)
			end
			corg_or_pv:Sub(stg)
		end
		if #corg>0 then
			Duel.SSet(tp,corg_or_pv)
			Duel.ConfirmCards(1-tp,corg_or_pv)
			ct=ct+#corg_or_pv
		end
	elseif waystring=="sp" then
		ct=rssf.SpecialSummon(corg_or_pv)
	end
	local og=ct>0 and Duel.GetOperatedGroup() or Group.CreateGroup()
	return og,ct
end
--cost: remove count form self
function rscost.rmct(cttype,ct1,ct2,issetlabel)
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk==0 then return c:IsCanRemoveCounter(tp,cttype,minct,REASON_COST) end
		if maxct>minct then
		   local rmlist={}
		   for i=minct,maxct do
			   table.insert(rmlist,i)
		   end
		   minct=Duel.AnnounceNumber(tp,table.unpack(rmlist))
		end
		c:RemoveCounter(tp,cttype,minct,REASON_COST)
		rscost.costinfo[e]=minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove count form self field
function rscost.rmct2(cttype,loc1,loc2,ct1,ct2,issetlabel)
	loc1=loc1 or LOCATION_MZONE
	loc2=loc2 or 0
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk==0 then return Duel.IsCanRemoveCounter(tp,loc1,loc2,cttype,minct,REASON_COST) end
		if maxct>minct then
		   local rmlist={}
		   for i=minct,maxct do
			   table.insert(rmlist,i)
		   end
		   minct=Duel.AnnounceNumber(tp,table.unpack(rmlist))
		end
		Duel.RemoveCounter(tp,1,0,cttype,minct,REASON_COST)
		rscost.costinfo[e]=minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove overlay card form self
function rscost.rmxyz(ct1,ct2,issetlabel)
	ct1=ct1 or 1
	ct2=ct2 or ct1
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetOverlayCount(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetOverlayCount() or ct2
		if chk==0 then return c:CheckRemoveOverlayCard(tp,minct,REASON_COST) end
		c:RemoveOverlayCard(tp,minct,maxct,REASON_COST)
		local rct=Duel.GetOperatedGroup():GetCount()
		rscost.costinfo[e]=rct
		if issetlabel then
		   e:SetLabel(rct)
		end
	end
end
--cost: if the cost is relate to the effect, use this (real cost set in the target)
function rscost.reglabel(labelcount)
	labelcount=labelcount or 100
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(labelcount)
		return true
	end
end
--cost: Pay LP
function rscost.lpcost(lp,isdirectly,islabel)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local clp=lp
		if rsof.Check_Boolean(lp) then clp=math.floor(Duel.GetLP(tp)/2) end
		if isdirectly then clp=Duel.GetLP(tp)-clp end
		if chk==0 then 
			return clp>0 and Duel.CheckLPCost(tp,clp)
		end
		Duel.PayLPCost(tp,clp)   
		rscost.costinfo[e]=clp
		if islabel then
			e:SetLabel(clp)
		end
	end
end
--cost: Pay Multiple LP
function rscost.lpcost2(lp,max,islabel)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local maxlp=Duel.GetLP(tp)
		if max and type(max)=="number" then
			maxlp=math.min(maxlp,max)
		end
		if type(islabel)=="nil" then islabel=true end
		if chk==0 then return Duel.CheckLPCost(tp,lp) end
		local costmaxlp=math.floor(maxlp/lp)
		local t={}
		for i=1,costmaxlp do
			t[i]=i*lp
		end
		local cost=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.PayLPCost(tp,cost)
		rscost.costinfo[e]=cost
		if islabel then
			e:SetLabel(cost)
		end
	end
end
--cost: tribute self 
function rscost.releaseself(mzone,exmzone)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsReleasable() and (not mzone or Duel.GetMZoneCount(tp,c,tp)>0) and (not exmzone or Duel.GetLocationCountFromEx(tp,tp,c,exmzone)>0) end
		Duel.Release(c,REASON_COST)
	end
end
--cost: register flag to limit activate (Quick Effect activates once per chain,e.g)
function rscost.regflag(flagcode,resettbl)
	if not resettbl then resettbl=RESET_CHAIN end
	if type(resettbl)~="table" then resettbl={resettbl} end
	local resetcount= resettbl[2]
	if not resetcount then resetcount=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		flagcode = flagcode or code
		if chk==0 then return c:GetFlagEffect(flagcode)==0 end
		c:RegisterFlagEffect(flagcode,resettbl[1],0,resetcount)
	end
end
function rscost.regflag2(flagcode,resettbl)
	if not resettbl then resettbl=RESET_CHAIN end
	if type(resettbl)~="table" then resettbl={resettbl} end
	local resetcount= resettbl[2]
	if not resetcount then resetcount=1 end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		flagcode = flagcode or code
		if chk==0 then return Duel.GetFlagEffect(tp,flagcode)==0 end
		Duel.RegisterFlagEffect(tp,flagcode,RESET_CHAIN,0,1)
	end
end
-------------------"Part_Condition_Function"---------------------

--Condition in Self Turn
function rscon.turns(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end 
--Condition in Oppo Turn
function rscon.turno(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end 
--Condition in Phase
function rscon.phase(p1,...)
	local parlist={p1,...}
	--phase pass: PHASE_DRAW - PHASE_STANDBY - PHASE_MAIN1 - PHASE_BATTLE_START - PHASE_BATTLE_STEP - PHASE_DAMAGE (start) - PHASE_DAMAGE_CAL (before dcal - dcaling - after dcal) - PHASE_DAMAGE (end) - PHASE_BATTLE - PHASE_MAIN2 - PHASE_END
	return function(e,p)
		local tp=p or e:GetHandlerPlayer()
		local turnp=Duel.GetTurnPlayer()
		local phase_bp=function()
			return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
		end
		local phase_dam=function()
			return Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
		end
		local phase_dambdcal=function()
			return Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated()
		end
		local phase_ndcal=function()
			return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
		end
		local stringlist={"dp","sp","mp1","bp","bsp","dam","damndcal","dambdcal","dcal","ndcal","mp2","ep"} 
		local phaselist={PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,phase_bp,PHASE_BATTLE_STEP,phase_dam,PHASE_DAMAGE,phase_dambdcal,PHASE_DAMAGE_CAL,phase_ndcal,PHASE_MAIN2,PHASE_END } 
		local mainstringlist={}
		local turnplayerlist={}
		local parlist2=rsof.String_Number_To_Table(parlist) 
		for _,pstring in pairs(parlist2) do
			local mainstring,splitstring=rsof.String_NoSymbol(pstring)
			table.insert(mainstringlist,mainstring)
			table.insert(turnplayerlist,splitstring)
		end
		local phaselist2=rsof.Table_Suit(mainstringlist,stringlist,phaselist)
		for index,phase in pairs(phaselist2) do
			if turnplayerlist[index] then
				if (turnplayerlist[index]=="_s" and turnp~=tp) or (turnplayerlist[index]=="_o" and turnp==tp ) then return false end
			end
			if type(phase)=="number" and Duel.GetCurrentPhase()==phase then return true 
			elseif type(phase)=="function" and phase() then return true 
			end
		end 
		return false 
	end
end
--Condition in Main Phase
function rscon.phmp(e)
	return rscon.phase("mp1,mp2")
end 
--Condition: Phase no damage calculate , for change atk/def
function rscon.adcon(e)
	return rscon.phase("ndcal")
end
--Condition: Battle Phase 
function rscon.phbp(e)
	return rscon.phase("bp")
end
--Condition: Phase damage calculate,but not calculate 
function rscon.dambdcal(e)
	return rscon.phase("dambdcal")
end
--Condition in ADV or SP Summon Sucess
function rscon.sumtype(sumtbl,sumfilter,matchall)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		sumfilter=sumfilter or aux.TRUE 
		local code=e:GetCode()
		local fieldres=(code==EVENT_SUMMON_SUCCESS or code==EVENT_SPSUMMON_SUCCESS or code==EVENT_FLIP_SUMMON_SUCCESS ) and e:IsHasType(EFFECT_TYPE_FIELD)
		local checkg=not fieldres and rsgf.Mix2(c) or eg:Clone()
		sumtbl=sumtbl or "sp"
		local tf=false
		local codetbl1={"sp","adv","rit","fus","syn","xyz","link","pen"}
		local codetbl2={ SUMMON_TYPE_SPECIAL,SUMMON_TYPE_ADVANCE,SUMMON_TYPE_RITUAL,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_PENDULUM }
		local stypetbl=rsof.Table_Suit(sumtbl,codetbl1,codetbl2)
		local stypeg=Group.CreateGroup()
		local filterg=Group.CreateGroup()
		for tc in aux.Next(checkg) do
			for _,stype in pairs(stypetbl) do
				if tc:IsSummonType(stype) then
					stypeg:AddCard(tc)
				end
			end 
			local mat=tc:GetMaterial()
			if sumfilter then
				local res=sumfilter(tc,e,tp,re,rp,mat)
				if res then filterg:AddCard(tc) end
			end
		end
		if #stypeg<=0 or (matchall and not stypeg:Equal(checkg)) then
			return false
		end
		if #filterg<=0 or (matchall and not filterg:Equal(checkg)) then
			return false
		end
		return true 
	end
end 
--Condition: Negate Effect/Activation
function rscon.disnegcon(disorneg,filterfun,playerfun)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
		local seq=nil
		if loc&LOCATION_MZONE ~=0 or loc&LOCATION_SZONE ~=0 then
			seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
		end
		local tg=nil
		if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		end
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
		if filterfun then 
			if type(filterfun)=="function" and not filterfun(e,tp,re,rp,tg,loc,seq) then return false end
			if type(filterfun)=="number" then
				if filterfun==1 and not (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end 
				if filterfun==2 and not re:IsActiveType(TYPE_MONSTER) then return false end
				if filterfun==3 and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
				if filterfun==4 and not re:IsActiveType(TYPE_TRAP+TYPE_SPELL) then return false end
			end
		end
		if playerfun and tp==rp then return false end
		return (disorneg=="dis" and Duel.IsChainDisablable(ev)) or (disorneg=="neg" and Duel.IsChainNegatable(ev))
	end 
end
function rscon.discon(filterfun,playerfun)
	return function(...)
		return rscon.disnegcon("dis",filterfun,playerfun)(...)
	end
end
function rscon.negcon(filterfun,playerfun)
	return function(...)
		return rscon.disnegcon("neg",filterfun,playerfun)(...)
	end
end
--Condition: Is exisit matching card
function rscon.excardfilter(filter,varlist,e,tp,eg,ep,ev,re,r,rp)
	return function(c)
		if not filter then return true end
		if #varlist==0 then return filter(c,e,tp,eg,ep,ev,re,r,rp) end
		return filter(c,table.unpack(rsof.Table_Mix(varlist,{e,tp,eg,ep,ev,re,r,r})))
	end
end
function rscon.excard(filter,loc1,loc2,ct,exceptg,...)
	local varlist={...}
	return function(e,tp,eg,ep,ev,re,r,rp)
		filter=filter or aux.TRUE 
		loc1=loc1 or LOCATION_MZONE 
		loc2=loc2 or 0
		ct= ct or 1
		tp= type(tp)=="number" and tp or e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(rscon.excardfilter(filter,varlist,e,tp,eg,ep,ev,re,r,rp),tp,loc1,loc2,ct,exceptg)
	end
end 
-- rscon.excard + Card.IsFaceup 
function rscon.excard2(filter,loc1,loc2,ct,exceptg,...)
	local filter2=aux.AND(filter,Card.IsFaceup)
	return rscon.excard(filter2,loc1,loc2,ct,exceptg,...)
end
--Condition: Summon monster to a link zone
function rscon.sumtolz(linkmfilter,summfilter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local zone=0
		local lmg=Group.CreateGroup()
		if rsof.Check_Boolean(linkmfilter) then
			lmg=rsgf.Mix2(c)
		else
			lmg=Duel.GetMatchingGroup(linkmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp,eg,ep,ev,re,rp)
		end
		for tc in aux.Next(lmg) do
			zone=zone|tc:GetLinkedZone(tp)
		end
		return eg:IsExists(rscon.sumtolz_filter,1,nil,zone,summfilter,e,tp,eg,ep,ev,re,rp)
	end
end 
function rscon.sumtolz_filter(c,zone,summfilter,e,tp,eg,ep,ev,re,rp)
	if summfilter and not summfilter(c,e,tp,eg,ep,ev,re,rp) then return false end
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1-tp then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end

-----------------"Part_Operation_Function"-------------------

--Quick operation: select and do operation 
function rsop.operation0(checkfun,endfun,...)
	local operationlist={rsop.list2(...)}
	return function(e,tp,eg,ep,ev,re,r,rp)
		if checkfun and not checkfun(e,tp,eg,ep,ev,re,r,rp) then return end
		rsop.OpeartionSelect(e,tp,eg,ep,ev,re,r,rp,endfun,operationlist)
	end
end
function rsop.operation(...)
	return rsop.operation0(nil,nil,...)
end
function rsop.operation2(endfun,...)
	return rsop.operation0(nil,endfun,...)
end
function rsop.operation3(checkfun,...)
	return rsop.operation0(checkfun,nil,...)
end
function rsop.target0(checkfun,endfun,...)
	return rstg.target0(checkfun,endfun,rsop.list(...))
end
function rsop.target(...)
	return rstg.target(rsop.list(...))
end
function rsop.target2(endfun,...)
	return rstg.target2(endfun,rsop.list(...))
end
function rsop.target3(checkfun,...)
	return rstg.target2(checkfun,rsop.list(...))
end
--operation select
function rsop.OpeartionSelect(e,tp,eg,ep,ev,re,r,rp,endfun,operationlist)
	local _,_,costtotalgroup,costrealgroup,costinfolist,costinfoindexlist = rstg.TargetSelectNoInfo(e,tp,eg,ep,ev,re,r,rp,operationlist)
	if endfun then endfun(costrealgroup,e,tp,eg,ep,ev,re,r,rp) end 
	return costtotalgroup,costrealgroup
end
--Operation: Negative Effect/Activate/Summon/SpSummon
function rsop.disnegop(disorneg,waystring)
	local fun=nil
	if disorneg=="dis" then fun=Duel.NegateEffect
	elseif disorneg=="neg" then fun=Duel.NegateActivation
	else fun=Duel.NegateSummon
	end
	local setfun=function(setc,setignore)
		return setc:IsSSetable(true)
	end
	if type(waystring)==nil then waystring="des" end
	if not waystring then waystring="nil" end
	return function(e,tp,eg,ep,ev,re,r,rp)
		local ct=0
		local rc=re:GetHandler()
		if disorneg=="sum" then 
			fun(eg)
			_,ct=rsop.operationcard(eg,waystring,REASON_EFFECT,e,tp,eg,ep,ev,re,r,rp)
		else
			if fun(ev) and re:GetHandler():IsRelateToEffect(re) and waystring~="nil" then
				_,ct=rsop.operationcard(eg,waystring,REASON_EFFECT,e,tp,eg,ep,ev,re,r,rp)
			end
		end
		return ct
	end
end
function rsop.disop(waystring)
	return function(...)
		return rsop.disnegop("dis",waystring)(...)
	end
end
function rsop.negop(waystring)
	return function(...)
		return rsop.disnegop("neg",waystring)(...)
	end
end
function rsop.negsumop(waystring)
	return function(...)
		return rsop.disnegop("sum",waystring)(...)
	end
end
--Operation: Select Card
function rsop.SelectCheck_Filter(filter,...)
	local filterpar={...}
	local filterpar2={}
	if type(filter)=="table" then
		for index,par in pairs(filter) do
			if index>=2 then
				--table.insert(filterpar2,par)
				filterpar2[index-1]=par
			end
		end
		filter=filter[1]
		filterpar=rsof.Table_Mix(filterpar2,filterpar)
	end
	return filter or aux.TRUE,filterpar
end
function rsop.SelectCheck_Solve(solvefun)
	local solveparlist={}
	local len=0
	if type(solvefun)=="table" then
		for index,par in pairs(solvefun) do
			if index>=2 then
				len=len+1
				--table.insert(solveparlist,par)
				solveparlist[len]=par
			end
		end
		solvefun=solvefun[1]
	end
	return solvefun,solveparlist,len
end
--Function:Select card by filter and do operation on it
function rsop.SelectSolve(selecthint,sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvefun,...)
	minct=minct or 1 
	maxct=maxct or minct
	local filter2,filterpar=rsop.SelectCheck_Filter(filter,...)
	local solvefun2,solvefunpar,len=rsop.SelectCheck_Solve(solvefun)
	if rsof.Check_Boolean(minct) then
		local g=Duel.GetMatchingGroup(sp,filter2,tp,loc1,loc2,exceptg,...)
		return rsgf.SelectSolve(g,selecthint,sp,filter2,minct,maxct,exceptg,solvefun,table.unpack(filterpar))
	else
		rshint.Select(sp,selecthint)
		local g=Duel.SelectMatchingCard(sp,filter2,tp,loc1,loc2,minct,maxct,exceptg,table.unpack(filterpar))
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not rsop.nohint then
			Duel.HintSelection(g)
		end
		--under bitch function because of lua table's last element cannot be "nil" ,but last solve parameter will often be "nil" 
		local solveparlist={}
		local len2=0
		for index,solvepar in pairs(solvefunpar) do 
			len2=len2+1
			solveparlist[len2]=solvepar
		end
		if rsop.solveprlen and rsop.solveprlen>len then
			for i=1,rsop.solveprlen-len do 
				len2=len2+1
				solveparlist[len2]=nil
			end
		end
		for index,solvepar in pairs({...}) do 
			len2=len2+1
			solveparlist[len2]=solvepar
		end
		local res=not solvefun and {g,g:GetFirst()} or {solvefun2(g,table.unpack(solveparlist))}
		rsop.solveprlen=nil
		rsop.nohint=false
		return table.unpack(res)
	end
end
function rsop.GetFollowingSolvepar(solvepar,parlen)
	solvepar=type(solvepar)=="table" and solvepar or {solvepar}
	rsop.solveprlen=parlen
	return solvepar
end
--Function:Select card and send to hand
function rsop.SelectToHand(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsop.SelectSolve("th",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoHand,table.unpack(solvepar)},...)
end
--Function:Select card and send to grave
function rsop.SelectToGrave(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("tg",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoGrave,table.unpack(solvepar)},...)
end
--Function:Select card and release
function rsop.SelectRelease(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("tg",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Release,table.unpack(solvepar)},...)
end
--Function:Select card and send to deck
function rsop.SelectToDeck(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	rsop.nohint=true
	return rsop.SelectSolve("td",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.SendtoDeck,table.unpack(solvepar)},...)
end
--Function:Select card and destroy
function rsop.SelectDestroy(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	rsop.nohint=true
	return rsop.SelectSolve("des",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Destroy,table.unpack(solvepar)},...)
end
--Function:Select card and remove
function rsop.SelectRemove(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,3)
	rsop.nohint=true
	return rsop.SelectSolve("rm",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,{rsop.Remove,table.unpack(solvepar)},...)
end
--Function:Select card and special summon
function rsop.SelectSpecialSummon(sp,filter,tp,loc1,loc2,minct,maxct,exceptg,solvepar,...)
	solvepar=type(solvepar)=="table" and solvepar or {solvepar} 
	local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local ex_par=not ... and {e,sp} or {...}
	return rsop.SelectSolve("sp",sp,filter,tp,loc1,loc2,minct,maxct,exceptg,rsop.SelectSpecialSummon_Operation(solvepar),table.unpack(ex_par) )
end
function rsop.SelectSpecialSummon_Operation(sumfunvarlist)
	return function(tg)
		if #tg<=0 then return 0,tg end
		local hintg=tg:Filter(Card.IsLocation,nil,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED)
		if #hintg>0 then
			Duel.HintSelection(tg)
		end
		return rssf.SpecialSummon(tg,table.unpack(sumfunvarlist)) 
	end
end
--Operation: Equip 
function rsop.eqop(e,eqc,eqtc,pos,opside)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if opside then tp=1-tp end
	if type(pos)=="nil" then pos=true end
	local vtype=aux.GetValueType(eqlist1)
	if rsof.Check_Boolean(eqlist1) then 
		eqc=rscf.GetRelationThisCard(e)
	elseif vtype=="Card" then
		eqc=eqlist1
	end
	vtype=aux.GetValueType(eqlist2)
	if rsof.Check_Boolean(eqlist2) then 
		eqtc=rscf.GetRelationThisCard(e)
	elseif vtype=="Card" then
		eqtc=eqlist2
	end
	if eqc==eqtc then return false end
	if eqc then
		if not ((eqc:IsLocation(LOCATION_SZONE) and eqc:IsControler(tp)) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (eqc:IsFacedown() and not pos) or not eqtc or eqtc:IsFacedown() then
			Duel.SendtoGrave(eqc,REASON_EFFECT)
		return false
		end
		local eqlimitfun=function(ee,ec)
			return ec==ee:GetLabelObject()
		end
		if Duel.Equip(tp,eqc,eqtc,pos)~=0 then
			local e1=nil
			if eqc:GetOriginalType()&TYPE_EQUIP ==0 then
				local flag=(eqc==c and EFFECT_FLAG_CANNOT_DISABLE or nil)
				e1=rsef.SV({c,eqc},EFFECT_EQUIP_LIMIT,eqlimitfun,nil,nil,rsreset.est,flag)
				e1:SetLabelObject(eqtc)
			else
				local elist={eqc:IsHasEffect(EFFECT_EQUIP_LIMIT)}
				e1=elist[1]
			end
			return true,eqc,eqtc,e1
		end
	end
	return false
end
--Operation function: for following operation, check hint 
function rsop.CheckOperationHint(g,hint,confirm)
	local ishint,isconfirm=false
	if rsof.Check_Boolean(hint,true) then ishint=true end
	if type(hint)=="nil" then ishint=g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)==#g end
	if rsof.Check_Boolean(confirm,true) then isconfirm=true end
	if type(confirm)=="nil" then isconfirm=g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)~=#g end
	if ishint then 
		Duel.HintSelection(g)
	end
	return ishint,isconfirm
end
--Operation function:Send to hand and confirm or hint 
function rsop.SendtoHand(corg,p,reason,hint,confirm)
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	reason= reason or REASON_EFFECT 
	local ishint,isconfirm=rsop.CheckOperationHint(g,hint,confirm)
	local ct=Duel.SendtoHand(g,p,reason)
	if ct>0 and isconfirm then
		p=p or g:GetFirst():GetControler()
		Duel.ConfirmCards(1-p,g)
	end
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Send to deck and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.SendtoDeck(corg,p,seq,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.SendtoDeck(g,p,seq,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end 
--Operation function:Send to grave and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.SendtoGrave(corg,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		reason=reason|REASON_RETURN 
	end
	local ct=Duel.SendtoGrave(g,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Release and hint 
--if you don't neet hint, best use normal Duel.SendtoDeck
function rsop.Release(corg,reason,hint)
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local f=function(c)
		return (c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsOnField()) or c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
	end
	local ct=0
	if g:IsExists(f,1,nil,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND) then
		ct=Duel.SendtoGrave(g,reason|REASON_RELEASE)
	else
		ct=Duel.Release(g,reason)
	end
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:destroy and hint
--if you don't neet hint, best use normal Duel.Destroy
function rsop.Destroy(corg,reason,desloc,hint)
	reason= reason or REASON_EFFECT 
	desloc= desloc or LOCATION_GRAVE 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.Destroy(g,reason,desloc)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Operation function:Remove and hint 
--if you don't neet hint, best use normal Duel.Remove
function rsop.Remove(corg,pos,reason,hint)
	pos= pos or POS_FACEUP 
	reason= reason or REASON_EFFECT 
	local g=rsgf.Mix2(corg)
	if #g<=0 then return 0,nil end
	rsop.CheckOperationHint(g,hint)
	local ct=Duel.Remove(g,pos,reason)
	local og=Duel.GetOperatedGroup()
	return ct,og,og:GetFirst()
end
--Function: N effects select 1
function rsop.SelectOption(p,...)
	local functionlist={...}
	local off=1
	local ops={}
	local opval={}
	for k,v in ipairs(functionlist) do
		if rsof.Check_Boolean(v) and k~=#functionlist then
			local selecthint=functionlist[k+1]
			if type(selecthint)=="table" then ops[off]=aux.Stringid(selecthint[1],selecthint[2])
			else
				ops[off]=selecthint
			end
			opval[off-1]=(k+1)/2
			off=off+1
		end
	end
	if #ops<=0 then 
		return nil
	else
		local final=functionlist[#functionlist]
		if #ops==1 and rsof.Check_Boolean(final) then
			return opval[0]
		else
			local op=Duel.SelectOption(p,table.unpack(ops))
			return opval[op]
		end
	end
end
--Function: Select many options (nexpage and lastpage)
function rsop.SelectOption_Page(p,hintlist1,...)
	local hintlist={hintlist1,...}
	local nextpage={m+1,4}
	local lastpage={m+1,5}
	local null={m+1,6}
	local agree={m+1,7}
	local op,currentpage=0,1
	local length=#hintlist
	local maxpage=length<=4 and 1 or math.ceil((length-1)/3)
	local pagehint={}
	for page=1,maxpage do 
		pagehint[page]={}
		if page==1 then
			pagehint[page]={hintlist[1],hintlist[2] or null,hintlist[3] or null,hintlist[4] or null}
		elseif page>1 then
			local index=page*3-1
			pagehint[page]={hintlist[index] or null,hintlist[index+1] or null,hintlist[index+2] or null}
		end
		if page~=1 then 
			table.insert(pagehint[page],1,lastpage)
		end
		if page~=maxpage then 
			table.insert(pagehint[page],5,nextpage)
		end
		if page==maxpage then 
			table.insert(pagehint[page],5,agree)
		end
	end
	local currentpage=1 
	repeat 
		op=Duel.SelectOption(p,rsof.Table_To_Desc(pagehint[currentpage]))+1
		--null
		if type(pagehint[currentpage][op])=="table" and pagehint[currentpage][op][1]==null[1] and pagehint[currentpage][op][2]==null[2] then op=0 end
		--action agree
		local res1=currentpage==maxpage and op==5
		--action selected
		local res2=op~=1 and op~=5
		--action selected first page
		local res3=op==1 and currentpage==1 
		--next page
		if op==5 and currentpage<maxpage then currentpage=currentpage+1 end
		--last page
		if op==1 and currentpage>1 then currentpage=currentpage-1 end
	until op~=0 and (res1 or res2 or res3)
	if op~=5 and op~=1 and currentpage~=1 then 
		op=3*currentpage+op-3
	end
	local isfinsh=currentpage==maxpage and op==5
	return isfinsh and 0 or op
end
--Function: Select number options
function rsop.AnnounceNumber(tp,maxdigit)
	maxdigit=maxdigit or 7
	if maxdigit>7 then maxdigit=7 end
	local selectnum={m+1,8}
	local confirm={m+1,9}
	local clear={m+1,10}
	local agree={m+1,7}
	local op,isfinsh=0,false
	local num,digitlevel,digitindex=0,1,maxdigit
	for digit=1,maxdigit do 
		digitlevel=digitlevel*(digit==1 and 1 or 10)
	end
	repeat 
		op=rsop.SelectOption_Page(tp,selectnum,confirm,nil,clear)
		if op==2 then
			Debug.Message("Confirm select number:" .. num)
		elseif op==3 then
			num=0
		elseif op==1 then
			for digit=1,maxdigit do
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m+2,7-digitindex))
				num=num+Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,0)*digitlevel
				digitlevel=digitlevel/10
				digitindex=digitindex-1
			end
		end
		digitlevel,digitindex=1,maxdigit
		for digit=1,maxdigit do 
			digitlevel=digitlevel*(digit==1 and 1 or 10)
		end
	until op==0
	return num
end
--Function: Select number options 2
function rsop.AnnounceNumber_List(tp,num1,...)
	local selectnum={m+1,8}
	local add={m+1,11}
	local confirm={m+1,9}
	local clear={m+1,10}
	local agree={m+1,7}   
	local num=0
	repeat 
		op=rsop.SelectOption_Page(tp,selectnum,add,confirm,clear)
		if op==3 then
			Debug.Message("Confirm select number:" .. num)
		elseif op==4 then
			num=0
		elseif op==1 then
			num=Duel.AnnounceNumber(tp,num1,...)
		elseif op==2 then
			num=num+Duel.AnnounceNumber(tp,num1,...)
		end
	until op==0
	return num
end

----------------"Part_ZoneSequence_Function"------------------

--get excatly colomn zone, import the seq
--zone[1][1] means your colomn Mzone, zone[1][2] means your colomn Szone, zone[1][3] means your colomn Mzone+Szone
--zone[2] is the same, zone[3] is zone[1]+zone[2] (all players)
--seq must use rsv.GetExcatlySequence to Get true sequence
function rszsf.GetExcatlyColumnZone(seq)
	local zone={}
	for i=0,1 do
		zone[i]={}
		if i==1 then seq=seq+16 end
		zone[i][1]=2^seq 
		zone[i][2]=(2^seq)*0x100
		zone[i][3]=zone[i][1]+zone[i][2]
	end 
	zone[3]={}
	zone[3][1]=zone[1][1]+zone[2][1]
	zone[3][2]=zone[1][2]+zone[2][2]
	zone[3][3]=zone[1][3]+zone[2][3]
	return zone
end
--Get Surrounding Zone (up,down,left & right zone)
--p:Use this player's camera to see the sequence, default cp
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone(c,p,truezone,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
end
----Get Surrounding Zone (up,down,left & right zone)
--Use sequence to get Surrounding Zone
--p: p's sequence
--contains: Include itself's zone(mid)
--truezone: 1-p's zone must * 0x10000
function rszsf.GetSurroundingZone2(seq,loc,cp,p,truezone,contains)
	local nozone={[0]=0,[1]=0}
	if not p then p=cp end
	if not rsof.Check_Boolean(truezone,false) then truezone=true end
	if not rsof.Check_Boolean(contains,false) then contains=true end
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rszsf.GetSurroundingZone2: Location is not on field")
		return nozone,nozone,nozone 
	end
	if loc==LOCATION_PZONE or (loc==LOCATION_SZONE and seq>4) then
		return nozone,nozone,nozone
	end
	if loc==LOCATION_SZONE and seq>4 then 
		return nozone,nozone,nozone 
	end
	local mzone={[0]=0,[1]=0}
	local szone={[0]=0,[1]=0}
	if loc==LOCATION_MZONE then
		if seq==0 or seq==5 then mzone[cp]=mzone[cp]+0x2 end
		if seq==4 or seq==6 then mzone[cp]=mzone[cp]+0x8 end
		if seq>0 and seq<4 then mzone[cp]=mzone[cp]+2^(seq-1)+2^(seq+1) end
		if seq==5 then mzone[1-cp]=mzone[1-cp]+0x8 end
		if seq==6 then mzone[1-cp]=mzone[1-cp]+0x2 end
		if seq==1 then 
			mzone[cp]=mzone[cp]+0x20 
			mzone[1-cp]=mzone[1-cp]+0x40 
		end
		if seq==3 then 
			mzone[cp]=mzone[cp]+0x40 
			mzone[1-cp]=mzone[1-cp]+0x20 
		end
		if seq<5 then szone[cp]=szone[cp]+2^seq end
		if contains then mzone[cp]=mzone[cp]+2^seq end
	elseif loc==LOCATION_SZONE then
		if seq==0 then szone[cp]=szone[cp]+0x2 end
		if seq==4 then szone[cp]=szone[cp]+0x8 end   
		if seq>0 and seq<4 then szone[cp]=szone[cp]+2^(seq-1)+2^(seq+1) end
		mzone[cp]=mzone[cp]+2^seq
		if contains then szone[cp]=szone[cp]+2^seq end
	end
	szone[0]=szone[0]*0x100
	szone[1]=szone[1]*0x100
	if truezone then
		mzone[1-p]=mzone[1-p]*0x10000
		szone[1-p]=szone[1-p]*0x10000
	end
	local ozone={}
	for i=0,1 do
		ozone[i]=mzone[i]+szone[i]
	end
	return mzone,szone,ozone
end

-------------------"Part_Group_Function"---------------------
--Get except group use for Duel.IsExistingMatchingCard, eg
function rsgf.GetExceptGroup(exceptfun,b4,e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local excepttype=aux.GetValueType(exceptfun)
	local exceptg=Group.CreateGroup()
	if excepttype=="Card" then 
		if excepttype==e:GetHandler() and b4 then 
			rsgf.Mix(exceptg,aux.ExceptThisCard(e))
		else
			exceptg:AddCard(exceptfun)
		end
	elseif excepttype=="Group" then exceptg:Merge(exceptfun)
	elseif excepttype=="boolean" then
		if excepttype and b4 then 
			rsgf.Mix(exceptg,aux.ExceptThisCard(e))
		else
			exceptg:AddCard(c)
		end
	elseif excepttype=="function" then
		exceptg=exceptfun(e,tp,eg,ep,ev,re,r,rp)
	end
	local ct=not exceptg and 0 or #exceptg
	return exceptg,ct
end
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup(c,contains)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
end
--Get Surrounding Group (up,down,left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup2(seq,loc,cp,contains)
	local f=function(c)
		return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone2(seq,loc,cp,cp,true,contains)
	local g=Duel.GetMatchingGroup(f,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=Group.CreateGroup()
	local zone=ozone[0]+ozone[1]
	for tc in aux.Next(g) do 
		local seq=tc:GetSequence()
		if not tc:IsControler(cp) then seq=seq+16 end
		local tczone=2^seq
		if tc:IsLocation(LOCATION_SZONE) then tczone=tczone*0x100 end
		if tczone&zone ~=0 then 
			sg:AddCard(tc)
		end
	end
	return sg
end
--Group effect: get adjacent group
function rsgf.GetAdjacentGroup(c,contains)
	return rsgf.GetAdjacentGroup2(c:GetSequence(),c:GetLocation(),c:GetControler(),contains)
end 
--Group effect: get adjacent group (use sequence)
function rsgf.GetAdjacentGroup2(seq,loc,tp,contains)
	local g=Group.CreateGroup()
	if seq>0 and seq<5 then
		rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq-1))
	end
	if seq<4 then
		rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq+1))
	end
	if contains then rsgf.Mix(g,Duel.GetFieldCard(tp,loc,seq)) end
	return g
end
--Group effect: Get Target Group for Operations
function rsgf.GetTargetGroup(targetfilter,...)
	local g,e,tp=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tg=g:Filter(rscf.TargetFilter,nil,e,tp,targetfilter,...)
	return tg,tg:GetFirst()
end
--Group effect: Mix Card & Group,add to the first group
function rsgf.Mix(g,...)
	local list={...} 
	for _,val in pairs(list) do
		if aux.GetValueType(val)=="Group" then
			g:Merge(val)
		elseif aux.GetValueType(val)=="Card" then
			g:AddCard(val)
		end
	end
	return g,#g 
end
Group.Mix=rsgf.Mix
--Group effect: Mix Card & Group,return new group
function rsgf.Mix2(...)
	local g=Group.CreateGroup()
	local list={...}
	for _,val in pairs(list) do
		if aux.GetValueType(val)=="Group" then
			g:Merge(val)
		elseif aux.GetValueType(val)=="Card" then
			g:AddCard(val)
		end
	end
	return g,#g
end
--Group effect:Change Group to Table
function rsgf.Group_To_Table(g)
	local cardlist={}
	for tc in aux.Next(g) do
		table.insert(cardlist,tc)
	end
	return cardlist
end
--Group effect:Change Group to Table
function rsgf.Table_To_Group(list)
	local group=Group.CreateGroup()
	for _,value in pairs(list) do
		if aux.GetValueType(value)=="Card" or aux.GetValueType(value)=="Group" then
			rsgf.Mix(group,value)
		end
	end
	return group 
end
--Group:Select card from group and do operation on it
function rsgf.SelectSolve(g,selecthint,sp,filter,minct,maxct,exceptg,solvefun,...)
	minct=minct or 1 
	maxct=maxct or minct
	local filter2,filterpar=rsop.SelectCheck_Filter(filter,...)
	local solvefun2,solvefunpar,len=rsop.SelectCheck_Solve(solvefun)
	local tg=Group.CreateGroup()
	if rsof.Check_Boolean(minct) then
		tg=g   
	else
		rshint.Select(sp,selecthint)
		tg=g:FilterSelect(sp,filter2,minct,maxct,exceptg,table.unpack(filterpar))
		if tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not rsop.nohint then
			Duel.HintSelection(tg)
		end
	end 
	--under bitch function because of lua table's last element cannot be "nil" ,but last solve parameter will often be "nil" 
	local solveparlist={}
	local len2=0
	for index,solvepar in pairs(solvefunpar) do 
		len2=len2+1
		solveparlist[len2]=solvepar
	end
	if rsop.solveprlen and rsop.solveprlen>len then
		for i=1,rsop.solveprlen-len do 
			len2=len2+1
			solveparlist[len2]=nil
		end
	end
	for index,solvepar in pairs({...}) do 
		len2=len2+1
		solveparlist[len2]=solvepar
	end
	local res=not solvefun and {tg,tg:GetFirst()} or {solvefun2(tg,table.unpack(solveparlist))}   
	rsop.nohint=false
	rsop.solveprlen=nil
	return table.unpack(res) 
end
Group.SelectSolve=rsgf.SelectSolve
--Group:Select card from group and send to hand
function rsgf.SelectToHand(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	return rsgf.SelectSolve(g,"th",sp,filter,minct,maxct,exceptg,{rsop.SendtoHand,table.unpack(solvepar)},...)
end
Group.SelectToHand=rsgf.SelectToHand
--Group:Select card from group and send to grave
function rsgf.SelectToGrave(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	return rsgf.SelectSolve(g,"tg",sp,filter,minct,maxct,exceptg,{rsop.SendtoGrave,table.unpack(solvepar)},...)
end
Group.SelectToGrave=rsgf.SelectToGrave
--Group:Select card from group and release
function rsgf.SelectRelease(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	return rsgf.SelectSolve(g,"tg",sp,filter,minct,maxct,exceptg,{rsop.Release,table.unpack(solvepar)},...)
end
Group.SelectRelease=rsgf.SelectRelease
--Group:Select card from group and send to deck
function rsgf.SelectToDeck(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,4)
	return rsgf.SelectSolve(g,"td",sp,filter,minct,maxc,t,exceptg,{rsop.SendtoDeck,table.unpack(solvepar)},...)
end
Group.SelectToDeck=rsgf.SelectToDeck
--Group:Select card from group and destroy
function rsgf.SelectDestroy(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,2)
	return rsgf.SelectSolve(g,"des",sp,filter,minct,maxct,exceptg,{rsop.Destroy,table.unpack(solvepar)},...)
end
Group.SelectDestroy=rsgf.SelectDestroy
--Group:Select card from group and remove
function rsgf.SelectRemove(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,3)
	return rsgf.SelectSolve(g,"rm",sp,filter,minct,maxct,exceptg,{rsop.Remove,table.unpack(solvepar)},...)
end
Group.SelectRemove=rsgf.SelectRemove
--Group:Select card from group and special summon
function rsgf.SelectSpecialSummon(g,sp,filter,minct,maxct,exceptg,solvepar,...)
	solvepar=rsop.GetFollowingSolvepar(solvepar,8)
	local e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local ex_par=not ... and {e,sp} or {...}
	return rsgf.SelectSolve(g,"sp",sp,filter,minct,maxct,exceptg,{rssf.SpecialSummon,table.unpack(solvepar)},table.unpack(ex_par))
end
Group.SelectSpecialSummon=rsgf.SelectSpecialSummon


-------------------"Part_Card_Function"---------------------

--Card function: local m and cm and cm.rssetcode 
function rscf.DefineCard(code,setcode)
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]   
	if setcode and not ccodem.rssetcode then
		ccodem.rssetcode=setcode
	end
	return code,ccodem
end
--Card function: rsxx.IsXSetXX
function rscf.DefineSet(setmeta,seriesstring,suffix)
	local prefixlist1={"","Fus","Link","Pre","Ori"} 
	local prefixlist1_fun={"","Fusion","Link","Previous","Original"}
	local prefixlist2={"","M","S","T","ST"} 
	local prefixlist2_fun={ nil,TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP,TYPE_SPELL+TYPE_TRAP }
	suffix=suffix or "" 
	for index1,prefix1 in pairs(prefixlist1) do 
		for index2,prefix2 in pairs(prefixlist2) do
			setmeta["Is"..prefix1.."Set"..prefix2..suffix]=rscf.DefineSet_Fun(prefixlist1_fun[index1],prefixlist2_fun[index2],seriesstring)
		end
	end
end
function rscf.DefineSet_Fun(prefix1,prefix2,seriesstring)
	return function(c)
		return rscf["Check"..prefix1.."SetCard"](c,seriesstring) and (not prefix2 or c:IsType(prefix2))
	end
end
--Register qucik attribute buff in cards
function rscf.QuickBuff(reglist,...)
	local c1,c2=rsef.GetRegisterCard(reglist)
	local bufflist={...}
	local reset=rsreset.est
	local reset2=c1~=c2 and rsreset.est or rsreset.est_d
	if #bufflist&1==1 then
		reset=bufflist[#bufflist]
		reset2=c1~=c2 and bufflist[#bufflist] or bufflist[#bufflist]|RESET_DISABLE 
	end
	local setlist={"atk","def","batk","bdef","atkf","deff"} 
	local uplist={"atk+","def+","lv+","rk+"}
	local changelist={"lv","rk","code","set","att","race"} 
	local addlist={"code+","set+","att+","race+"}
	local limitlist={"dis","dise","tri","atk","atkan","datk","ress","resns","td","th","cp","cost"} 
	local matlimitlist={"fus","syn","xyz","link"}
	local leavelist={"leave"}
	local phaselist={"ep","sp"}
	local funlist=rsof.Table_Mix(setlist,uplist,changelist,addlist,limitlist,matlimitlist,leavelist)
	local funlistatt=rsof.Table_Mix(setlist,uplist,changelist,addlist)
	--local nulllist={}
	--for i=1,#stringlist do 
		--table.insert(nulllist,"hape")
	--end
	local effectlist={}
	for index,value in pairs(bufflist) do
		if index&1==1 then
			local vallist=type(bufflist[index+1])~=table and {bufflist[index+1]} or bufflist[index+1]
			local stringlist=rsof.String_Number_To_Table(value)
			local _,effectvaluelist=rsof.Table_Suit(value,funlist,{},vallist)
			for k,codestring in pairs(stringlist) do
				if rsof.Table_List(funlistatt,codestring) then
					e1=rsef.SV_ATTRIBUTE(reglist,codestring,effectvaluelist[k],nil,reset2)
				end
				if rsof.Table_List(limitlist,codestring) then
					e1=rsef.SV_LIMIT(reglist,codestring,effectvaluelist[k],nil,reset,"cd")
				end
				if rsof.Table_List(matlimitlist,codestring) then
					e1=rsef.SV_CANNOT_BE_MATERIAL(reglist,codestring,effectvaluelist[k],nil,reset,"cd")
				end
				if rsof.Table_List(leavelist,codestring) then
					e1=rsef.SV_REDIRECT(reglist,codestring,effectvaluelist[k],nil,rsreset.ered,"cd")
				end 
				table.insert(effectlist,e1)  
			end
		end
	end
	return table.unpack(effectlist)
end
--Card effect:Auxiliary.ExceptThisCard + Card.IsFaceup()
function rscf.GetRelationThisCard(e)
	if not e then e=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT) end
	local c=aux.ExceptThisCard(e)
	if c and c:IsFaceup() then return c else return nil end
end
--Card/Summon effect: Set Special Summon Produce
function rscf.SetSpecialSummonProduce(cardtbl,range,con,op,desctbl,ctlimittbl,resettbl)
	local tc1,tc2,ignore=rsef.GetRegisterCard(cardtbl)
	if not desctbl then desctbl=rshint.spproc end
	local flag=not tc2:IsSummonableCard() and "uc,cd" or "uc" 
	local e1=rsef.Register(cardtbl,EFFECT_TYPE_FIELD,EFFECT_SPSUMMON_PROC,desctbl,ctlimittbl,nil,flag,range,rscf.SetSpecialSummonProduce_con(con),nil,nil,op,nil,nil,nil,resettbl)
	return e1
end
rssf.SetSpecialSummonProduce=rscf.SetSpecialSummonProduce
function rscf.SetSpecialSummonProduce_con(con)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return con(e,c,tp)
	end
end
--Card/Summon effect: Is monster can normal or special summon
function rscf.SetSummonCondition(cardtbl,isnsable,sumvalue,iseffectspsum,resettbl)
	local tc1,tc2,ignore=rsef.GetRegisterCard(cardtbl)
	if tc2:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not isnsable then
		if iseffectspsum or (sumvalue and sumvalue==rsval.spcons) then
			--tc2:EnableUnsummonable()
		else
			tc2:EnableReviveLimit()
		end
	end
	if not sumvalue then sumvalue=aux.FALSE end
	local e1=rsef.SV(cardtbl,EFFECT_SPSUMMON_CONDITION,sumvalue,nil,nil,resettbl,"uc,cd")
	return e1
end 
rssf.SetSummonCondition=rscf.SetSummonCondition
--Check Built-in SetCode / Series Main Set
function rscf.CheckSetCardMainSet(c,settype,series1,...) 
	local stringlist=rsof.String_Number_To_Table({series1,...})
	local codelist={}
	local effectlist={}
	local addcodelist={}
	if settype=="base" then
		codelist={c:GetCode()} 
		effectlist={c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="fus" then
		codelist={c:GetFusionCode()}
		effectlist={c:IsHasEffect(EFFECT_ADD_FUSION_SETCODE),c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="link" then
		codelist={c:GetLinkCode()}
		effectlist={c:IsHasEffect(EFFECT_ADD_LINK_SETCODE),c:IsHasEffect(EFFECT_ADD_SETCODE)} 
	elseif settype=="org" then
		codelist={c:GetOriginalCode()}
		effectlist={}
	elseif settype=="pre" then
		codelist={c:GetPreviousCodeOnField()}
		effectlist=rscf.Previous_Set_Code_List
	end
	for _,effect in pairs(effectlist) do
		local string=rsef.valinfo[effect]
		if type(string)=="string" then 
			table.insert(addcodelist,string)
		end
	end
	for _,code in ipairs(codelist) do 
		local setcodestring
		local res=not _G["c"..code] and true or false
		if res then _G["c"..code]={} end
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			setcodestring=_G["c"..code].rssetcode
		end
		if res then _G["c"..code]=nil end
		if setcodestring then
			local setcodelist=rsof.String_Number_To_Table(setcodestring)
			for _,string in pairs(stringlist) do 
				for _,setcode in pairs(setcodelist) do
					local setcodelist2=rsof.String_Split(setcode, '_')
					if rsof.Table_List(setcodelist2,string) then return true end
				end
			end
		end
	end
	if #addcodelist>0 then
		for _,string in pairs(stringlist) do 
			for _,setcode in pairs(addcodelist) do
				local addcodelist2=rsof.String_Split(setcode, '_')
				if rsof.Table_List(addcodelist2,string) then return true end
			end
		end
	end
	return false 
end 
--Check Built-in Base SetCode / Series
function rscf.CheckSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"base",series1,...) 
end
Card.CheckSetCard=rscf.CheckSetCard
--Check Built-in Fusion SetCode / Series
function rscf.CheckFusionSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"fus",series1,...) 
end
Card.CheckFusionSetCard=rscf.CheckFusionSetCard
--Check Built-in Link SetCode / Series
function rscf.CheckLinkSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"link",series1,...) 
end
Card.CheckLinkSetCard=rscf.CheckLinkSetCard
--Check Built-in Original SetCode / Series
function rscf.CheckOriginalSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"org",series1,...)
end
Card.CheckOriginalSetCard=rscf.CheckOriginalSetCard
--Check Built-in Previous SetCode / Series
function rscf.CheckPreviousSetCard(c,series1,...) 
	return rscf.CheckSetCardMainSet(c,"pre",series1,...)
end
Card.CheckPreviousSetCard=rscf.CheckPreviousSetCard
--Card/Summon effect:Record Summon Procedure
function rscf.RecordSummonProcedure()
	if rscf.RecordSummonProcedure_Switch then return end
	rscf.RecordSummonProcedure_Switch=true
	local f=Effect.CreateEffect
	Effect.CreateEffect=function(c)
		local e0=f(c)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(rscf.RecordSummonProcedure_Operation)
		Duel.RegisterEffect(e1,0)
		Effect.CreateEffect=f
		return e0
	end
end
rscf.RecordSummonProcedure()
function rscf.RecordSummonProcedure_Operation(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,0,0xff,0xff,nil,rscf.extype-TYPE_PENDULUM)
	local f6=aux.AddSynchroProcedure
	local f7=aux.AddSynchroMixProcedure
	local f8=aux.AddXyzProcedure
	local f9=aux.AddXyzProcedureLevelFree
	local f10=aux.AddLinkProcedure
	aux.AddSynchroProcedure=rscf.GetBaseSynchroProduce1
	aux.AddSynchroMixProcedure=rscf.GetBaseSynchroProduce2
	aux.AddXyzProcedure=rscf.GetBaseXyzProduce1
	aux.AddXyzProcedureLevelFree=rscf.GetBaseXyzProduce2
	aux.AddLinkProcedure=rscf.GetBaseLinkProduce1
	for tc in aux.Next(g) do
		--Method ResetEffect/ReplaceEffect is issue at Raise Event 
		tc:ResetEffect(tc:GetOriginalCode(),RESET_CARD)
		local mt=getmetatable(tc)
		if mt.initial_effect then
			mt.initial_effect(tc) 
		end
		
	end
	aux.AddSynchroProcedure=f6
	aux.AddSynchroMixProcedure=f7
	aux.AddXyzProcedure=f8
	aux.AddXyzProcedureLevelFree=f9
	aux.AddLinkProcedure=f10
	e:Reset()
end 
function rscf.GetBaseSynchroProduce1(c,f1,f2,minc,maxc)
	if c.dark_synchro==true then
		rscf.AddSynchroProcedureSpecial(c,aux.NonTuner(f1),nil,nil,rscf.DarkTuner(f2),minc,maxc or 99)
	else
		rscf.AddSynchroProcedureSpecial(c,aux.Tuner(f1),nil,nil,f2,minc,maxc or 99)
	end
end
function rscf.GetBaseSynchroProduce2(c,f1,f2,f3,f4,minc,maxc,gc)
	rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc or 99,gc)
end
function rscf.XyzProcedure_TransformLv(xyzc,lv)
	return  function(g)
				return g:FilterCount(Card.IsXyzLevel,nil,xyzc,lv)==#g
			end
end
function rscf.GetBaseXyzProduce1(c,f,lv,ct,alterf,desc,maxct,op)
	rscf.AddXyzProcedureSpecial(c,f,rscf.XyzProcedure_TransformLv(c,lv),ct,maxct or ct,alterf,desc,op)
end 
function rscf.GetBaseXyzProduce2(c,f,gf,minc,maxc,alterf,desc,op)
	rscf.AddXyzProcedureSpecial(c,f,gf,minc,maxc or minc,alterf,desc,op)
end
function rscf.GetBaseLinkProduce1(c,f,min,max,gf)
	rscf.AddLinkProcedureSpecial(c,f,min,max,gf)
end
--Check is matg exist syncard's right materials
function rscf.GetLocationCountFromEx(...)
	return 1
end
function rscf.CheckSynchroMaterial(sync,tp,smat,matg,min,max,checkft,checkmust,checkpend)
	max=max or 99
	local proce=sync.rs_synchro_parameter[1]
	if not proce then return false end
	local con=proce:GetCondition()
	local f=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2=aux.MustMaterialCheck 
	aux.MustMaterialCheck=checkmust and aux.MustMaterialCheck or aux.TRUE 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL  
	local res= not con or con(nil,sync,smat,matg,min,max)   
	Duel.GetLocationCountFromEx=f
	aux.MustMaterialCheck=f2
	TYPE_PENDULUM = ctype
	return res
end
--Select syncard's right materials 
function rsgf.SelectSynchroMaterial(sync,tp,smat,matg,min,max,checkft,checkmust,checkpend)
	max=max or 99
	local proce=sync.rs_synchro_parameter[1]
	if not proce then return false end
	local tg=proce:GetTarget()
	local f=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2=aux.MustMaterialCheck 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL
	aux.MustMaterialCheck=checkmust and aux.MustMaterialCheck or aux.TRUE   
	local e1=rsef.SV({sync,true},rscode.Synchro_Material,nil,0xff) 
	tg(e1,tp,nil,nil,nil,nil,nil,nil,1,sync,smat,matg,min,max)
	local g=e1:GetLabelObject()
	Duel.GetLocationCountFromEx=f
	aux.MustMaterialCheck=f2  
	TYPE_PENDULUM = ctype  
	if not g then e1:Reset() return false end
	local og=g:Clone()
	og:KeepAlive()
	e1:Reset()
	return og
end
--Card/Summon function: Custom Synchro Procedure 
rscf.AddSynchroProcedure=aux.AddSynchroProcedure
function rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc,gc)
	local mt=getmetatable(c)
	if not rscf.AddSynchroProcedureSpecial_Switch then
		rscf.AddSynchroProcedureSpecial_Switch=true
		rscf.GetSynMaterials	=   aux.GetSynMaterials
		aux.GetSynMaterials  =  rscf.GetSynMaterials2
		rscf.SynMixCheckGoal	=   aux.SynMixCheckGoal
		aux.SynMixCheckGoal  =  rscf.SynMixCheckGoal2
		rscf.SynMixCondition	=   aux.SynMixCondition
		aux.SynMixCondition  =  rscf.SynMixCondition2
		rscf.SynMixTarget   =   aux.SynMixTarget
		aux.SynMixTarget  =  rscf.SynMixTarget2
		rscf.SynMixFilter4  = aux.SynMixFilter4
		aux.SynMixFilter4   = rscf.SynMixFilter42
		rscf.SynMixOperation	=   aux.SynMixOperation
		aux.SynMixOperation = rscf.SynMixOperation2  
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rscf.SynMixCondition2(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_synchro_parameter then
		mt.rs_synchro_parameter={e1,f1,f2,f3,f4,minc,maxc or minc,gc}
	end
	return e1
end
--Get synchro materials, fix for special material
function rscf.GetSynMaterials2(tp,syncard)
	local mg1=rscf.GetSynMaterials(tp,syncard)
	local mg2=Duel.GetMatchingGroup(rscf.ExtraSynMaterialsFilter,tp,0xff,0xff,mg1,syncard,tp)
	if #mg2>0 then mg1:Merge(mg2) end
	return mg1
end
function rscf.ExtraSynMaterialsFilter(c,sc,tp)
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Synchro_Material,tp) and c:IsCanBeSynchroMaterial(sc) 
end
function rscf.SCheckOtherMaterial(c,mg,sc,tp)
	local le={c:IsHasEffect(rscode.Extra_Synchro_Material,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,sc,mg) then return true end
	end
	return false
end
function rscf.SUncompatibilityFilter(c,sg,sc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not rscf.SCheckOtherMaterial(c,mg,sc,tp)
end
function rscf.SynMixCheckGoal2(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	mgchk= mgchk or rssf.synchro_material_group_check
	local mg=rsgf.Mix2(sg,sg1)
	--step 1, check extra material
	if mg:IsExists(rscf.SUncompatibilityFilter,1,nil,mg,syncard,tp) then return false end
	--step 2, check material group filter function
	if syncard.rs_synchro_material_check and not syncard.rs_synchro_material_check(mg,syncard,tp) then return false end
	--step 3, check level fo dark_synchro and non-level_synchro 
	local f=Card.GetLevel
	local darktunerg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
	local darktunerlv=darktunerg:GetSum(Card.GetSynchroLevel,syncard)
	Card.GetLevel=function(sc)
		if syncard.dark_synchro and syncard==sc then
			return darktunerlv*2-f(sc)
		end
		if sc.rs_synchro_level then return sc.rs_synchro_level
		else return f(sc)
		end
	end
	--step 4, check Ladian 1, use material's custom lv (if any)
	local f2=Card.GetSynchroLevel
	Card.GetSynchroLevel=function(sc,sc2)
		local lvcheck=syncard.rs_synchro_ladian 
		if type(lvcheck)=="number" then return lvcheck
		elseif type(lvcheck)=="function" then 
			local lv=lvcheck(sc,mg,sc2,tp)
			if type(lv)=="number" then return lv 
			else return f2(sc,sc2) 
			end
		end
	end
	local bool1=rscf.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	Card.GetSynchroLevel=f2
	--step 5, check Ladian 2, use material's base lv
	local bool2=rscf.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	Card.GetLevel=f
	return bool1 or bool2
end
function rscf.SynMixCondition2(f1,f2,f3,f4,minc,maxc,gc)
	return function(e,c,smat,mg1,min,max)
		if mg1 and aux.GetValueType(mg1)~="Group" then return false end
		return rscf.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)(e,c,smat,mg1,min,max)
	end
end
function rscf.SynMixTarget2(f1,f2,f3,f4,minc,maxc,gc)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
		rssf.synchro_material_group_check=nil
		if mg1 then
			rssf.synchro_material_group_check=true
		end
		return rscf.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	end
end
function rscf.SynMixFilter42(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	return rscf.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
end
function rscf.SynMixOperation2(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				rscf.SynchroCustomOperation(g,c,e,tp)
				g:DeleteGroup()
			end
end
function rscf.SynchroCustomOperation(mg,c,e,tp)
	c:SetMaterial(mg)  
	rscf.SExtraMaterialCount(mg,sync,tp)
	--case 1, Summon Effect Custom
	if rssf.SynchroMaterialAction then
		rssf.SynchroMaterialAction(mg,c,e,tp)
		rssf.SynchroMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_synchro_material_action then
		c.rs_synchro_material_action(mg,c,e,tp)
	--case 3, Base Summon Procedure
	else
		Duel.SendtoGrave(mg,REASON_SYNCHRO+REASON_MATERIAL)
	end
end
function rscf.SExtraMaterialCount(mg,sync,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(rscode.Extra_Synchro_Material,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			if not f or f(te,sync,sg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card/Summon function: Special Synchro Summon Procedure
--Force a synchro level for a synchro monster's synchro procedure
function rscf.AddSynchroProcedureSpecial_SynchroLevel(c,lv,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_level then
		local mt=getmetatable(c)
		mt.rs_synchro_level=lv 
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end
--Dark Synchro Procedure
function rscf.AddSynchroProcedureSpecial_DarkSynchro(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.dark_synchro then
		local mt=getmetatable(c)
		mt.dark_synchro=true
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end
--Ladian's Synchro Procedure (treat tuner as another lv)
function rscf.AddSynchroProcedureSpecial_Ladian(c,f1,lv,f2,f3,f4,minc,maxc,extrafilter)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_ladian then
		local mt=getmetatable(c)
		mt.rs_synchro_ladian={lv,extrafilter}
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,f1,f2,f3,f4,minc,maxc)
	return e1
end
--Check Synchro Material Group for Synchro Procedure
function rscf.AddSynchroProcedureSpecial_MaterialCheck(c,checkfilter,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_material_check then
		local mt=getmetatable(c)
		mt.rs_synchro_material_check=checkfilter
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end

--Custom Synchro Materials' Action
function rscf.AddSynchroProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_material_action then
		local mt=getmetatable(c)
		mt.rs_synchro_material_action=actionfun
	end
	local e1=rscf.AddSynchroProcedureSpecial(c,...)
	return e1
end 

--Card/Summon function: Custom Xyz Procedure 
function rscf.AddXyzProcedureSpecial(c,f,gf,minc,maxc,alterf,desc,op)
	local mt=getmetatable(c)
	if not rscf.AddXyzProcedureSpecial_Switch then
		rscf.AddXyzProcedureSpecial_Switch=true
		rscf.XyzLevelFreeCondition2  =  aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeCondition2  =  rscf.XyzLevelFreeCondition22
		rscf.XyzLevelFreeTarget2  =  aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeTarget2  =  rscf.XyzLevelFreeTarget22
		rscf.XyzLevelFreeOperation2  =  aux.XyzLevelFreeOperation2
		aux.XyzLevelFreeOperation2  =  rscf.XyzLevelFreeOperation22
		rscf.XyzLevelFreeGoal  =  aux.XyzLevelFreeGoal
		rscf.XyzLevelFreeFilter =   aux.XyzLevelFreeFilter
		aux.XyzLevelFreeFilter  =   rscf.XyzLevelFreeFilter2
	end
	--aux.XyzLevelFreeGoal  =  rscf.XyzLevelFreeGoal2(minc,maxc or minc)
	alterf = alterf or aux.FALSE 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	--if alterf then
		maxc= maxc or minc
		e1:SetCondition(rscf.XyzLevelFreeCondition22(f,gf,minc,maxc,alterf,desc,op))
		e1:SetTarget(rscf.XyzLevelFreeTarget22(f,gf,minc,maxc,alterf,desc,op))
		e1:SetOperation(rscf.XyzLevelFreeOperation22(f,gf,minc,maxc,alterf,desc,op))
	--[[else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f,gf,minc,maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f,gf,minc,maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f,gf,minc,maxc))--]]
	--end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_xyz_parameter then
		mt.rs_xyz_parameter={e1,f1,f2,f3,f4,maxc,gc}
	end
	return e1
end
function rscf.XCheckUtilityMaterial(c,mg,xyzc,tp)
	local le={c:IsHasEffect(rscode.Utility_Xyz_Material,tp)}
	if #le==0 then return 1,{1} end
	local maxreduce=1
	local reducelist={1}
	for _,te in pairs(le) do
		local val=te:GetValue()
		local reduce=1
		if type(val)=="number" then reduce=val end
		if type(val)=="function" then reduce=val(te,xyzc,mg,tp) end
		maxreduce=math.max(maxreduce,reduce or 2) 
		table.insert(reducelist,reduce or 2)
	end
	return maxreduce,reducelist
end
function rscf.XUncompatibilityFilter(c,sg,xyzc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not rscf.XCheckOtherMaterial(c,mg,xyzc,tp,sg)
end
function rscf.XCheckOtherMaterial(c,mg,xyzc,tp,sg)
	local le={c:IsHasEffect(rscode.Extra_Xyz_Material,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,xyzc,mg,sg) then return true end
	end
	return false
end
function rscf.IsCanBeXyzMaterial(c,xyzc)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsType(TYPE_MONSTER) then return c:IsCanBeXyzMaterial(xyzc) end
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		local elist={c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL)}
		for _,e in pairs(elist) do
			local val=e:GetValue()
			if not val or val(e,xyzc) then return false end
		end
	end
	return true
end
function rscf.XyzLevelFreeFilter2(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup()) and rscf.IsCanBeXyzMaterial(c,xyzc) and (not f or f(c,xyzc))   
end
function rscf.ExtraXyzMaterialsFilter(c,xyzc,tp,f)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Xyz_Material,tp) and rscf.IsCanBeXyzMaterial(c,xyzc) and (not f or f(c))
end
function rscf.XyzLevelFreeGoal2(minct,maxct,og)
	return function(g,tp,xyzc,gf)
		--case 1, extra material check 
		if not og and g:IsExists(rscf.XUncompatibilityFilter,1,nil,g,xyzc,tp) then return false end
		--case 2, normal check
		if (gf and not gf(g,og,tp,xyzc)) or Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
		--if #g<minct then return false end
		if #g>maxct then return false end
		--case 3, utility check, separate mg and ug for easy calculate
		local ug=g:Filter(Card.IsHasEffect,nil,rscode.Utility_Xyz_Material,tp)
		local mg=g:Clone()
		mg:Sub(ug)
		local totalreducelist={}
		local sumlist={#mg}
		for tc in aux.Next(ug) do 
			local ct=0
			local sumlist2=rsof.Table_Clone(sumlist)
			local _,reducelist=rscf.XCheckUtilityMaterial(tc,g,xyzc,tp)
			for i,reduce in pairs(reducelist) do 
				ct=ct+1
				for j,prereduce in pairs(sumlist2) do 
					if j>1 then
						ct=ct+1
					end
					sumlist[ct]=prereduce+reduce
				end
			end
		end
		for _,matct in pairs(sumlist) do
			if matct>=minct and matct<=maxct then return true end
		end
		return false
	end
end
function rscf.XyzLevelFreeCondition22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				--other material
				local mgextra=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
					mgextra=Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter,tp,0xff,0xff,mg,c,tp,f)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,op):Filter(Auxiliary.MustMaterialCheck,nil,tp,EFFECT_MUST_BE_XMATERIAL)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					--if minc>maxc then return false end
				end
				mg=mg:Filter(rscf.XyzLevelFreeFilter2,nil,c,f)
				if mgextra and #mgextra>0 then mg:Merge(mgextra) end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				--minc to 1 for utility xyz material
				local res=mg:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc,maxc,og),1,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function rscf.XyzLevelFreeTarget22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				--other material
				local mg3=nil
				if og then
					mg=og
					mg3=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
					mg3=Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter,tp,0xff,0xff,mg,c,tp,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				local mg2=mg:Filter(rscf.XyzLevelFreeFilter2,nil,c,f)
				mg3:Merge(mg2)
				--other material
				Duel.SetSelectedCard(sg)
				local b1=mg3:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc,maxc,og),1,maxc,tp,c,gf)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg3:SelectSubGroup(tp,rscf.XyzLevelFreeGoal2(minc,maxc,og),true,1,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function rscf.XyzLevelFreeOperation22(f,gf,minct,maxct,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					rscf.XyzCustomOperation(og,c,e,tp,false)
				else
					local mg=e:GetLabelObject()
					rscf.XyzCustomOperation(mg,c,e,tp,true)
				end
			end
end
function rscf.XyzCustomOperation(mg,c,e,tp,checkog)
	c:SetMaterial(mg)
	if checkog then
		rscf.XExtraMaterialCount(mg,c,tp)
	end
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	tc=mg:GetNext()
	end 
	--case 1, Summon Effect Custom (Book of Cain)
	if rssf.XyzMaterialAction then
		rssf.XyzMaterialAction(mg,sg,c,e,tp)
		rssf.XyzMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_xyz_material_action then
		c.rs_xyz_material_action(mg,sg,c,e,tp)
	--case 3, Base Alterf Xyz Procedure
	elseif e:GetLabel()==1 then
		if #sg>0 then
			Duel.Overlay(c,sg)
		end
		Duel.Overlay(c,mg)
	--case 4, Base Normal Xyz Procedure
	else
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Overlay(c,mg)
	end
	--if used hand material, shuffle hand
	if mg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.ShuffleHand(tp)	
	end
	mg:DeleteGroup()
end
function rscf.XExtraMaterialCount(mg,xyzc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(rscode.Extra_Xyz_Material,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			if not f or f(te,xyzc,sg,mg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card/Summon function: Special Xyz Summon Procedure
--Custom Xyz Materials' Action
function rscf.AddXyzProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt=getmetatable(c)
		mt.rs_xyz_material_action=actionfun
	end
	local e1=rscf.AddXyzProcedureSpecial(c,...)
	return e1
end
function rscf.XyzMaterialAction(c,actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt=getmetatable(c)
		mt.rs_xyz_material_action=actionfun
	end
end


--Card/Summon function: Custom Link Procedure 
function rscf.AddLinkProcedureSpecial(c,f,min,max,gf)
	if not rscf.AddLinkProcedureSpecial_Switch then
		rscf.AddLinkProcedureSpecial_Switch=true
		rscf.LCheckOtherMaterial   =   aux.LCheckOtherMaterial 
		aux.LCheckOtherMaterial =   rscf.LCheckOtherMaterial2
		rscf.GetLinkMaterials   =   aux.GetLinkMaterials
		aux.GetLinkMaterials	=   rscf.GetLinkMaterials2
		rscf.LinkOperation  =  aux.LinkOperation
		aux.LinkOperation  =  rscf.LinkOperation2
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
	e1:SetOperation(rscf.LinkOperation2(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_link_parameter then
		local mt=getmetatable(c)
		mt.rs_link_parameter={e1,f,min,max,gf}
	end
	return e1
end
function rscf.GetLinkMaterials2(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,0xff,0xff,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function rscf.LinkOperation2(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				rscf.LinkCustomOperation(g,c,e,tp,og)
				g:DeleteGroup()
			end
end
function rscf.LinkCustomOperation(mg,c,e,tp,checkog)
	c:SetMaterial(mg)
	if checkog then
		Auxiliary.LExtraMaterialCount(mg,c,tp)
	end
	--case 1, Summon Effect Custom
	if rssf.LinkMaterialAction then
		rssf.LinkMaterialAction(mg,c,e,tp,checkog)
		rssf.LinkMaterialAction=nil
	--case 2, Summon Procedure Custom 
	elseif c.rs_link_material_action then
		c.rs_link_material_action(mg,c,e,tp,checkog)
	--case 3, Base Summon Procedure
	else
		Duel.SendtoGrave(mg,REASON_LINK+REASON_MATERIAL)
	end
end
--Change aux function to repair bug in multiple other material link
function rscf.LCheckOtherMaterial2(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	if #le==0 then return true end
	for _,te in pairs(le) do
		local f=te:GetValue()
		if not f or f(te,lc,mg) then return true end
	end
	return false
end
--Card/Summon function: Special Link Summon Procedure
--Custom Link Materials' Action
function rscf.AddLinkProcedureSpecial_CustomAction(c,actionfun,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt=getmetatable(c)
		mt.rs_link_material_action=actionfun
	end
	local e1=rscf.AddLinkProcedureSpecial(c,...)
	return e1
end
function rscf.LinkMaterialAction(c,actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt=getmetatable(c)
		mt.rs_link_material_action=actionfun
	end
end



--Card effect: Set field info
function rscf.SetFieldInfo(c)
	local seq=c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc=c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp=c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	if loc==LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND then
		Debug.Message("rscf.SetFieldInfo: Location is not on field.")
	else
		rscf.fieldinfo[c]={seq,loc,cp}
	end
end
--Card effect: Get field info
function rscf.GetFieldInfo(c)
	if not rscf.fieldinfo[c] or not rscf.fieldinfo[c][1] then
		Debug.Message("rscf.GetFieldInfo: Didn't use rscf.SetFieldInfo set field information")
		return nil
	end
	return rscf.fieldinfo[c][1],rscf.fieldinfo[c][2],rscf.fieldinfo[c][3]
end
--Card effect: Check if c is surrounding to tc 
function rscf.IsSurrounding(c,tc)
	if not tc:IsOnField() then return false end
	local g=rsgf.GetSurroundingGroup(tc,true)
	return g:IsContains(c)
end
--Card effect: Check if c is surrounding to tc, c is previous on field
function rscf.IsPreviousSurrounding(c,tc)
	local seq,loc,p=c:GetPreviousSequence(),c:GetPreviousLocation(),c:GetPreviousControler()
	if loc&LOCATION_ONFIELD==0 or not tc:IsOnField() then
		return false
	end
	local mzone,szone,ozone=rszsf.GetSurroundingZone(tc)
	local zone=ozone[0]+ozone[1]
	if p~=tc:GetControler() then seq=seq+16 end
	local czone=2^seq
	if loc==LOCATION_SZONE then czone=czone*0x100 end
	return czone&zone ~=0   
end
--Card effect: Get First Target Card for Operations
function rscf.TargetFilter(c,e,tp,filter,...)
	local varlist={...}
	if not c:IsRelateToEffect(e) then return false end
	if not filter then return true end
	if not ... then return filter(c,e,tp) 
	else
		return filter(c,table.unpack(rsof.Table_Mix(varlist,{e,tp})))
	end
end
function rscf.GetTargetCard(targetfilter,...)
	local tc=Duel.GetFirstTarget()
	if not tc then return nil end
	local e,tp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	if rscf.TargetFilter(tc,e,tp,targetfilter,...) then return tc 
	else return nil
	end
end
--Card effect: qucik register dark_synchro type 
function rscf.EnableDarkSynchroAttribute(cardtbl,resettbl)
	local c1,val2=rsef.GetRegisterCard(cardtbl)
	if not resettbl and c1==val2 and not val2:IsStatus(STATUS_COPYING_EFFECT) and not c1.dark_synchro then 
		local mt=getmetatable(val2) 
		mt.dark_synchro=true
	end
	if resettbl then 
		local e1=rsef.SV_ADD(cardtbl,"type","TYPE_DARKSYNCHRO",nil,resettbl,"cd,ch",rshint.darksynchro)
		return e1
	end
end
--Card effect: qucik register dark_tuner type 
function rscf.EnableDarkTunerAttribute(cardtbl,resettbl)
	local c1,val2=rsef.GetRegisterCard(cardtbl)
	if not resettbl and c1==val2 and not val2:IsStatus(STATUS_COPYING_EFFECT) and not c1.dark_tuner then 
		local mt=getmetatable(val2) 
		mt.dark_tuner=true
	end
	if resettbl then 
		local e1=rsef.SV_ADD(cardtbl,"type","TYPE_DARKTUNER",nil,resettbl,"cd,ch",rshint.darktuner)
		return e1
	end
end
--Card filter: Is Dark Synchro
function rscf.IsDarkSynchro(c)
	return c.dark_synchro==true
end
--Card filter: Is Dark Tuner 
function rscf.IsDarkTuner(c)
	return rscf.DarkTuner(nil)(c)
end
--Card filter: Dark Tuner for Dark Synchro Summon
function rscf.DarkTuner(f,...)
	local ext_params={...}
	return  function(target)
				local typelist={target:IsHasEffect(EFFECT_ADD_TYPE)}
				local bool=false
				for _,e in pairs(typelist) do
					if rsef.valinfo[e]=="TYPE_DARKTUNER" then
						bool=true
					break 
					end
				end
				return (target.dark_tuner or bool) and aux.Tuner(f,table.unpack(ext_params))(target)
			end
end
--Card filter: face up + filter
function rscf.FilterFaceUp(f,...)
	local ext_params={...}
	return  function(target)
				return f(target,table.unpack(ext_params)) and target:IsFaceup()
			end
end
--Card filter function: Special Summon Filter
function rscf.spfilter(f,...)
	local ext_params={...}
	return function(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not f or f(c,table.unpack(rsof.Table_Mix(ext_params,{e,tp}))))
	end
end
function rscf.spfilter2(f,...)
	local ext_params={...}
	return function(c,e,tp)
		if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return false end
		if not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not f or f(c,table.unpack(rsof.Table_Mix(ext_params,{e,tp}))))
	end
end
--Card function: Get same type base set
function rscf.GetSameType_Base(c,waystring,type1,...)
	local gettypefun=Card.GetType
	if waystring=="previous" 
		then gettypefun=Card.GetPreviousTypeOnField 
	elseif waystring=="original" 
		then gettypefun=Card.GetOriginalType
	end
	local typelist= type1 and {type1,...} or { TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP } 
	local typetotal=0
	local typetotallist={}
	for _,ctype in pairs(typelist) do
		if gettypefun(c)&ctype==ctype then
			typetotal=typetotal|ctype
			if not rsof.Table_List(typetotallist,ctype) then
				table.insert(typetotallist,ctype) 
			end
		end
	end
	return typetotal,typetotallist
end
--Card function: Get same type 
function rscf.GetSameType(c,...)
	return rscf.GetSameType_Base(c,nil,...)
end
--Card function: Get same previous type 
function rscf.GetPreviousSameType(c,...)
	return rscf.GetSameType_Base(c,"previous",...)
end
--Card function: Get same original type 
function rscf.GetOriginalSameType(c,...)
	return rscf.GetSameType_Base(c,"original",...)
end
--Card Funcion: Check complex card type base set
function rscf.IsComplexType_Base(c,waysting,type1,type2,...)
	local gettypefun=Card.GetType
	if waystring=="previous" 
		then gettypefun=Card.GetPreviousTypeOnField 
	elseif waystring=="original" 
		then gettypefun=Card.GetOriginalType
	end
	local typelist={type1,type2,...}
	local publictype=0
	if rsof.Check_Boolean(type2) then
		publictype=type1
		typelist={...}
	end
	for _,ctype in pairs(typelist) do 
		if type(ctype)=="string" then
			if ctype=="TYPE_SPELL" then
				if gettypefun(c)==TYPE_SPELL then return true end
			elseif ctype=="TYPE_TRAP" then
				if gettypefun(c)==TYPE_TRAP then return true end
			end
		else
			if gettypefun(c)&(ctype|publictype)==(ctype|publictype) then return true end
		end
	end 
	return false
end
--Card Funcion: Check Complex card type
function rscf.IsComplexType(c,...)
	return rscf.IsComplexType_Base(c,nil,...)
end
Card.IsComplexType=rscf.IsComplexType
--Card Funcion: Check Complex card previous type
function rscf.IsPreviousComplexType(c,...)
	return rscf.IsComplexType_Base(c,"previous",...)
end
Card.IsPreviousComplexType=rscf.IsPreviousComplexType
--Card Funcion: Check Complex card original type
function rscf.IsOriginalComplexType(c,...)
	return rscf.IsComplexType_Base(c,"original",...)
end
Card.IsOriginalComplexType=rscf.IsOriginalComplexType
--Card Funcion: Check complex card reason 
function rscf.IsComplexReason(c,reason1,reason2,...)
	local reasonlist={reason1,reason2,...}
	local publicreason=0
	if rsof.Check_Boolean(reason2) then
		publicreason=reason1
		reasonlist={...}
	end
	for _,reason in pairs(reasonlist) do
		if c:GetReason()&(reason|publicreason)==(reason|publicreason) then return true end
	end
	return false 
end
Card.IsComplexReason=rscf.IsComplexReason

-------------------"Part_Hint_Function"---------------------

--Hint function: HINT_SELECTMSG
function rshint.Select(p,cate)
	local hintstring=nil
	if type(cate)~="string" then hintstring=cate end
	local _,catelist=rsef.GetRegisterCategory(cate)
	local hintmsg=rsef.GetDefaultHintString(catelist,nil,nil,hintstring)
	Duel.Hint(HINT_SELECTMSG,p,hintmsg) 
end

-------------------"Part_Other_Function"---------------------

--split the string, ues "," as delimiter
function rsof.String_Split(stringinput,delimiter)  
	delimiter=delimiter or ',' 
	local pos,arr = 0, {}  
	--case string list 
	if delimiter==',' then
		for st,sp in function() return string.find(stringinput, delimiter, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		return arr
	--case set code
	elseif delimiter=='_' then
		for st,sp in function() return string.find(stringinput, delimiter, pos, true) end do  
			table.insert(arr, string.sub(stringinput, pos, st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr, string.sub(stringinput, pos)) 
		local arr2={}
		local string2=arr[1]
		for k,v in ipairs(arr) do 
			if k==1 then table.insert(arr2, string2) 
			else
				string2=string2 .. "_" .. v
				table.insert(arr2, string2)
			end
		end
		return arr2
	end 
end  
--get no symbol string (for rscf.ComplexFilter and rscon.phmp)
function rsof.String_NoSymbol(string)
	local len=string.len(string)
	local symbolist1={"+","-","~","="}
	local symbolist2={"++","--"}
	local symbolist3={"_s","_o"}
	local string2=string.sub(string,-2)
	local string3=string.sub(string,-2)
	local string1=string.sub(string2,-1)
	if rsof.Table_List(symbolist2,string2) then
		return string.sub(string,1,len-2),string2
	elseif rsof.Table_List(symbolist1,string1) then
		return string.sub(string,1,len-1),string1
	elseif rsof.Table_List(symbolist3,string3) then
		return string.sub(string,1,len-2),string3
	else
		return string
	end
end
--Sting to Table (for different formats)
--you can use "a,b,c" or {"a,b,c"} or {"a","b","c"} as same
--return {"a","b","c"}
function rsof.String_Number_To_Table(value)
	local table1={}
	if type(value)=="string" then
		table1=rsof.String_Split(value)
	elseif type(value)=="number" then
		table1={value}
	elseif type(value)=="table" then
		for _,v in ipairs(value) do
			if type(v)=="string" then
				local table2=rsof.String_Split(v)
				for _,v2 in ipairs(table2) do
					table.insert(table1,v2) 
				end
			else 
				table.insert(table1,v)
			end
		end
	end
	return table1
end
--suit 2 tables (for rsv_E_SV)
function rsof.Table_Suit(value1,value2,value3,value4,value4nosuit)
	local table1=rsof.String_Number_To_Table(value1)
	local table2=rsof.String_Number_To_Table(value2)
	local table3=value3
	local table4=value4
	if type(value4)~="table" then
		table4={value4}
	end
	local resulttbl1,resulttbl2={},{}
	for k1,v1 in ipairs(table1) do
		for k2,v2 in ipairs(table2) do
			if v1==v2 then
				table.insert(resulttbl1,value3[k2]) 
				if #table4==1 and not value4nosuit then
				   table.insert(resulttbl2,table4[1])
				else
				   table.insert(resulttbl2,table4[k1])
				end
			end
		end
	end
	return resulttbl1,resulttbl2,resulttbl1[1],resulttbl2[1]
end
--other function: Find correct element in table
function rsof.Table_List(rtable,element)
	for k,v in ipairs(rtable) do
		if v==element then
			return true,k 
		end
	end
	return false,nil
end
--Other function: make mix type valuelist1 (can be string, table or string+table) become int table, string will be suitted with valuelistall and stringlistall to index the correct int 
function rsof.Mix_Value_To_Table(valuelist1,stringlistindex,valuelistindex)
	if type(valuelist1)~="table" then
		valuelist1={valuelist1}
	end
	local numvalue=0		--1+2+3=6
	local numvaluelist={}   --{1,2,3}
	local mixstringlist={}  --{"td_t,se,th"}
	local stringlist={}  --{"td_t","se","th"}
	for _,mixvalue in pairs(valuelist1) do
		if type(mixvalue)=="number" then 
			if numvalue&mixvalue==0 then
				numvalue=numvalue|mixvalue
				table.insert(numvaluelist,numvalue)
				local _,_,string=rsof.Table_Suit(mixvalue,valuelistindex,stringlistindex) 
				if string then
					table.insert(stringlist,string)   
				end
			end   
		elseif type(mixvalue)=="string" and not rsof.Table_List(mixstringlist,mixvalue) then
			table.insert(mixstringlist,mixvalue)
		end
	end
	for _,mixstring in pairs(mixstringlist) do 
		local mixstringlist2=rsof.String_Split(mixstring) 
		for _,mixstring2 in pairs(mixstringlist2) do
			local mixstringlist3=rsof.String_Split(mixstring2,'_')
			local _,_,numvalue2=rsof.Table_Suit(mixstringlist3[1],stringlistindex,valuelistindex) 
			if numvalue2 and numvalue&numvalue2==0 then
				numvalue=numvalue|numvalue2
				table.insert(numvaluelist,numvalue2)
			end
			if not rsof.Table_List(stringlist,mixstring2) then
				table.insert(stringlist,mixstring2)   
			end
		end
	end
	return numvalue,numvaluelist,stringlist
end
--other function: Find Intersection element in 2 table2
function rsof.Table_Intersection(table1,...)
	local intersectionlist={}
	local tablelist={...}
	for _,element1 in pairs(table1) do 
		table.insert(intersectionlist,element1)
		for _,table2 in pairs(tablelist) do
			if not rsof.Table_List(table2,element1) then 
				table.remove(intersectionlist)
			break 
			end
		end
	end
	return #intersectionlist>0,intersectionlist
end
--other function: Clone Table
function rsof.Table_Clone(table)
	local t2 = {}
	for k,v in pairs(table) do
		t2[k] = v
	end
	return t2
end
--other function: Mix Table
function rsof.Table_Mix(table1,...)
	local resultlist={}
	local list={table1,...}
	local len=0
	for _,tab in pairs(list) do
		for _,value in pairs(tab) do
			--table.insert(resultlist,value)
			len=len+1
			resultlist[len]=value
		end
	end
	return resultlist
end
--other function: table to desc ({m,1} to aux.Stringid(m,1))
function rsof.Table_To_Desc(hintlist)
	local newlist={}
	for _,hint in pairs(hintlist) do
		if type(hint)=="table" then
			table.insert(newlist,aux.Stringid(hint[1],hint[2]))
		elseif type(hint)=="number" then
			table.insert(newlist,hint)
		end
	end
	return table.unpack(newlist)
end
--other function: check a value is true or false
function rsof.Check_Boolean(value,booleanvaule)
	if type(booleanvaule)=="nil" or booleanvaule==true then return 
		type(value)=="boolean" and value==true
	else
		return type(value)=="boolean" and value==false
	end
end 
-------------------"Hape"---------------------
rsof.Escape_Old_Functions()