if AD_Database_2 then return end
AD_Database_2=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702601") end) then require("script/c53702601") end
SNNM=SNNM or {}
local cm=SNNM
function cm.RabbitTeam(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(cm.RabbitTeamspcon)
	e1:SetOperation(cm.RabbitTeamspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCondition(cm.RabbitTeamrecon)
	e2:SetValue(LOCATION_DECK)
	c:RegisterEffect(e2)
	if not RabbitTeam_Check then
		RabbitTeam_Check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)RabbitTeam_Place_Confirm_Check=false end)
		Duel.RegisterEffect(ge,tp)
		local f1=Duel.ConfirmDecktop
		Duel.ConfirmDecktop=function(tp,ct)
			if ct<5 and not RabbitTeam_Place_Confirm_Check then
				local g=Duel.GetDecktopGroup(tp,ct)
				local t={}
				for tc in aux.Next(g) do for i=1,4 do if tc["Rabbit_Team_Number_"..i] and not SNNM.IsInTable(i,t) then table.insert(t,i) end end end
				for _,v in ipairs(t) do Duel.RegisterFlagEffect(tp,53755000+v,RESET_PHASE+PHASE_END,0,1) end
			end
			RabbitTeam_Place_Confirm_Check=false
			return f1(tp,ct)
		end
		local f2=Duel.MoveSequence
		Duel.MoveSequence=function(...)
			RabbitTeam_Place_Confirm_Check=true
			return f2(...)
		end
	end
	return e2
end
function cm.RabbitTeamspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local num=53755000
	for i=1,4 do if c["Rabbit_Team_Number_"..i] then num=num+i end end
	return Duel.GetFlagEffect(tp,num)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.RabbitTeamspop(e,tp,eg,ep,ev,re,r,rp,c)
	local num=53755000
	for i=1,4 do if c["Rabbit_Team_Number_"..i] then num=num+i end end
	local ct=Duel.GetFlagEffect(tp,num)
	Duel.ResetFlagEffect(tp,num)
	for i=1,ct-1 do Duel.RegisterFlagEffect(tp,num,RESET_PHASE+PHASE_END,0,1) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetOperation(cm.RTreset1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.RTreset2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+53728000)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.RTreset3)
	Duel.RegisterEffect(e4,tp)
end
function cm.RTreset1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53728000,re,r,rp,ep,ev)
	e:Reset()
end
function cm.RTreset2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53755008,re,r,rp,ep,ev)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.RTreset3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.RabbitTeamrecon(e)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=c:GetControler()
end
function cm.Global_in_Initial_Reset(c,t)
	local le={Duel.IsPlayerAffectedByEffect(0,53702800)}
	for _,v in pairs(le) do
		if v:GetOwner()==c then
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	for _,v in pairs(t) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(53702800)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(v)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.DressamAdjust(c)
	if not Doremy_Adjust then
		Doremy_Adjust=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_COST)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetOperation(cm.Dressamcheckop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge2,0)
		local ge2_1=ge1:Clone()
		ge2_1:SetCode(EFFECT_MSET_COST)
		Duel.RegisterEffect(ge2_1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		ge3:SetOperation(cm.Dressamsreset)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
		local ge4_1=ge3:Clone()
		ge4_1:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge4_1,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		ge6:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge6,0)
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_CHAIN_SOLVING)
		ge7:SetOperation(cm.Dressamcount)
		Duel.RegisterEffect(ge7,0)
		local ge8=Effect.CreateEffect(c)
		ge8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge8:SetCode(EVENT_CHAIN_SOLVED)
		ge8:SetOperation(cm.Dressamcreset)
		Duel.RegisterEffect(ge8,0)
	end
end
function cm.Dressamcheckop(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=true
end
function cm.Dressamsreset(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=false
end
function cm.Dressamcount(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=true
end
function cm.Dressamcreset(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=false
end
function cm.DressamLocCheck(tp,usep,z)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,usep,LOCATION_REASON_TOFIELD,z)>0 then return true end
	if not Duel.IsPlayerAffectedByEffect(tp,53760022) then return false end
	for i=0,4 do
		local fc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if z&(1<<i)~=0 and fc and fc:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,fc,usep,LOCATION_REASON_TOFIELD,1<<i)>0 then return true end
	end
	return false
end
function cm.DressamSPStep(tc,tp,tgp,pos,z)
	local zone=z
	if Duel.IsPlayerAffectedByEffect(tp,53760022) then
		zone=0
		local ct=0
		for i=0,4 do
			if z&(1<<i)~=0 and cm.DressamLocCheck(tgp,tp,1<<i) then
				zone=zone|(1<<i)
				ct=ct+1
			end
		end
		if zone==0 then return false end
		if ct~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53760022,0))
			if tp==tgp then zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,0x7f&(~zone)) else
				zone=Duel.SelectField(tp,1,0,LOCATION_MZONE,0x7f&(~zone))
				zone=zone>>16
			end
		end
		local fc=Duel.GetFieldCard(tgp,LOCATION_MZONE,math.log(zone,2))
		if fc and fc:IsType(TYPE_EFFECT) then Duel.Destroy(fc,REASON_RULE) end
	end
	return Duel.SpecialSummonStep(tc,0,tp,tgp,false,false,pos,zone)
end
function cm.Ranclock(c,cat,att1,op,att2)
	aux.AddCodeList(c,53763001)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53763001,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+cat)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.Ranclockspcon1)
	e1:SetTarget(cm.Ranclocksptg1)
	e1:SetOperation(cm.Ranclockspop1(att1,op))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53763001,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.Ranclockspcon2)
	e2:SetTarget(cm.Ranclocksptg2)
	e2:SetOperation(cm.Ranclockspop2(att2))
	c:RegisterEffect(e2)
	return e1,e2
end
function cm.Ranclockspcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and ((aux.exccon(e) or e:GetHandler():IsPreviousLocation(LOCATION_HAND)) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.Ranclockdfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function cm.Ranclocksptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(c:GetOriginalCode())<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.Ranclockdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.Ranclockspop1(att1,op)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(att1)
			c:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function cm.Ranclockspcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.Ranclockspfilter(c,e,tp)
	return c:IsCode(53763001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.Ranclocksptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.Ranclockspfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.Ranclockspop2(att2)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.Ranclockspfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(att2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.TentuScout(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(function(e,c)return c:IsFaceup() and c:IsAttribute(e:GetHandler():GetAttribute())end)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:IsReason(REASON_SUMMON) and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_RELEASE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(53764000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1104)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.Tentuthcon)
	e5:SetTarget(cm.Tentuthtg)
	e5:SetOperation(cm.Tentuthop)
	c:RegisterEffect(e5)
end
function cm.Tentuthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53764000)>0
end
function cm.Tentuthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.Tentuthop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
end
--1
function cm.ActivatedAsSpellorTrap(c,otyp,loc,setava,owne)
	local e1=nil
	if owne then e1=owne else
		e1=Effect.CreateEffect(c)
		if otyp&(TYPE_TRAP+TYPE_QUICKPLAY)~=0 then
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		else e1:SetType(EFFECT_TYPE_IGNITION) end
		e1:SetRange(loc)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		c:RegisterEffect(e1)
	end
	local e1_1=Effect.CreateEffect(c)
	local e2=Effect.CreateEffect(c)
	local e3=Effect.CreateEffect(c)
	if not setava then
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(53765098)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(loc)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		c:RegisterEffect(e2)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetRange(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		c:RegisterEffect(e3)
	else
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(53765098)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		Duel.RegisterEffect(e2,0)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetLabel(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		Duel.RegisterEffect(e3,0)
		--cm.Global_in_Initial_Reset(c,{e2,e3})
	end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(53765096)
	e2_1:SetRange(loc|LOCATION_ONFIELD)
	e2_1:SetLabel(otyp)
	e2_1:SetLabelObject(e2)
	c:RegisterEffect(e2_1)
	if owne then return e1_1,e2,e3,e2_1 else return e1,e1_1,e2,e3 end
end
function cm.AASTadjustop(otyp,ext)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local adjt={}
	if ext then
		if type(ext)=="table" then adjt=ext else adjt={ext} end
	else adjt={e:GetLabelObject()} end
	if #adjt==0 then e:Reset() return end
	for _,te in pairs(adjt) do
	local c=te:GetHandler()
	if not c:IsStatus(STATUS_CHAINING) and c:IsStatus(STATUS_EFFECT_ENABLED) then
		local xe={c:IsHasEffect(53765099)}
		for _,v in pairs(xe) do v:Reset() end
	end
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	xe1:Reset()
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for _,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,false,te))
				end
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,true,te))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,true,te))
				end
			end
		end
	end
	xe1:Reset()
	end
	end
end
function cm.AASTbchval(_val,te)
	return function(e,re,...)
				if re==te then return false end
				return _val(e,re,...)
			end
end
function cm.AASTchval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.AASTchtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.AASTactarget(e,te,tp)
	if e:GetRange()==0 then
		local ce=e:GetLabelObject()
		return te:GetHandler()==e:GetOwner() and ce and te==ce and ce:GetHandler():IsLocation(e:GetLabel())
	else return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject() end
end
function cm.AASTcostchk(otyp)
	return  function(e,te,tp)
--Debug.Message(9999)
				if e:GetRange()==0 then
					local ce=e:GetLabelObject()
					if ce then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or ce:GetHandler():IsLocation(LOCATION_SZONE) or otyp&0x80000~=0 else e:Reset() return true end
				else return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:GetHandler():IsLocation(LOCATION_SZONE) or otyp&0x80000~=0 end
	end
end
function cm.AASTcostop(otyp)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe1=cm.AASTregi(c,te)
	if otyp&0x80000~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		if c:IsLocation(LOCATION_SZONE) then
			Duel.MoveSequence(c,5)
			if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
		else
			c:SetCardData(4,0x80002)
			Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
			c:SetCardData(4,0x21)
		end
		if c:IsPreviousLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if c:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(otyp)
	c:RegisterEffect(e0,true)
	if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP)
		c:SetStatus(STATUS_EFFECT_ENABLED,false)
	elseif not c:IsLocation(LOCATION_SZONE) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	if c:IsPreviousLocation(LOCATION_HAND) then c:SetStatus(STATUS_ACT_FROM_HAND,true) end
	xe1:SetLabel(c:GetSequence()+1,otyp)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:CreateEffectRelation(te)
	local te2=te:Clone()
	c:RegisterEffect(te2,true)
	e:SetLabelObject(te2)
	local le1={c:IsHasEffect(53765098)}
	for _,v in pairs(le1) do v:SetLabelObject(te2) end
	local le2={c:IsHasEffect(53765096)}
	for _,v in pairs(le2) do v:GetLabelObject():SetLabelObject(te2) end
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.AASTrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	if not c:IsType(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
	end
end
function cm.AASTrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	re:Reset()
end
function cm.AASTregi(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(53765099)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.MultipleGroupCheck(c)
	if not AD_Multiple_Group_Check then
		AD_Multiple_Group_Check=true
		Duel.RegisterFlagEffect(0,53759000,0,0,0,0)
		local ADIMI_IsExistingMatchingCard=Duel.IsExistingMatchingCard
		local ADIMI_SelectMatchingCard=Duel.SelectMatchingCard
		local ADIMI_GetMatchingGroup=Duel.GetMatchingGroup
		Duel.IsExistingMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		Duel.SelectMatchingCard=function(sp,f,p,s,o,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,s,o,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectMatchingCard(sp,f,p,s,o,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		Duel.GetMatchingGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_GetMatchingGroupCount=Duel.GetMatchingGroupCount
		Duel.GetMatchingGroupCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_GetFirstMatchingCard=Duel.GetFirstMatchingCard
		Duel.GetFirstMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_IsExists=Group.IsExists
		Group.IsExists=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExists(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExists(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_Filter=Group.Filter
		Group.Filter=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Filter(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Filter(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_FilterCount=Group.FilterCount
		Group.FilterCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_Remove=Group.Remove
		Group.Remove=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Remove(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Remove(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_SearchCard=Group.SearchCard
		Group.SearchCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_FilterSelect=Group.FilterSelect
		Group.FilterSelect=function(g,p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_Filter(g,f,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_FilterSelect(g,p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_CheckSubGroup=Group.CheckSubGroup
		Group.CheckSubGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_SelectSubGroup=Group.SelectSubGroup
		Group.SelectSubGroup=function(g,p,f,bool,min,max,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			f(g,...)
			--ADIMI_CheckSubGroup(g,f,min,max,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectSubGroup(g,p,f,bool,min,max,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_IsExistingTarget=Duel.IsExistingTarget
		Duel.IsExistingTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=ADIMI_IsExistingTarget(...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_SelectTarget=Duel.SelectTarget
		Duel.SelectTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=ADIMI_SelectTarget(...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_DiscardHand=Duel.DiscardHand
		Duel.DiscardHand=function(p,f,min,max,reason,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_HAND,LOCATION_HAND,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_DiscardHand(p,f,min,max,reason,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_SelectReleaseGroup=Duel.SelectReleaseGroup
		Duel.SelectReleaseGroup=function(p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroup(p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		local ADIMI_SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		Duel.SelectReleaseGroupEx=function(p,f,min,max,r,bool,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			if bool then ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,ex,...) else ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...) end
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroupEx(p,f,min,max,r,bool,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
	end
end
--2
function cm.SetAsSpellorTrapCheck(c,type)
	local mt=getmetatable(c)
	mt.SSetableMonster=true
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(type)
	c:RegisterEffect(e0)
	if not AD_SetAsSpellorTrap_Check then
		AD_SetAsSpellorTrap_Check=true
		local ADIMI_IsSSetable=Card.IsSSetable
		Card.IsSSetable=function(sc,bool)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local b=true
			if sc.initial_effect and sc.SSetableMonster and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			else b=ADIMI_IsSSetable(sc,bool) end
			return b
		end
	end
end
function cm.ActivatedAsSpellorTrapCheck(c)
	if not AD_ActivatedAsSpellorTrap_Check then
		AD_ActivatedAsSpellorTrap_Check=true
		cm.MultipleGroupCheck(c)
		local ADIMI_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res=true
			if ac:GetFlagEffect(53757050)>0 then
				res=false
				ac:ResetFlagEffect(53757050)
			end
			local le={ADIMI_GetActivateEffect(ac)}
			local xe={ac:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				if #le>0 then
					if res and ae:GetLabelObject() then
						for k,v in pairs(le) do
							if v==ae:GetLabelObject() then
								table.insert(le,1,ae)
								table.remove(le,k+1)
								break
							end
						end
					else le={ae} end
				else le={ae} end
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			if not ae and Dimpthox_Imitation then
				for _,v in pairs(Dimpthox_Imitation) do if v:GetOwner()==ac then table.insert(le,v) end end
			end
			return table.unpack(le)
		end
		local ADIMI_CheckActivateEffect=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local le={ADIMI_CheckActivateEffect(ac,...)}
			local xe={ac:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				le={ae}
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			return table.unpack(le)
		end
		local ADIMI_IsActivatable=Effect.IsActivatable
		Effect.IsActivatable=function(re,...)
			if re then return ADIMI_IsActivatable(re,...) else return false end
		end
		local ADIMI_IsType=Card.IsType
		Card.IsType=function(rc,type)
			local res=ADIMI_IsType(rc,type)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not rc:IsLocation(LOCATION_MZONE)
			if ae and (res1 or res2) then res=(type&typ~=0) end
			return res
		end
		local ADIMI_CGetType=Card.GetType
		Card.GetType=function(rc)
			local res=ADIMI_CGetType(rc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not rc:IsLocation(LOCATION_MZONE)
			if ae and (res1 or res2) then res=typ end
			return res
		end
		local ADIMI_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(rc,...)
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if v:GetLabelObject() and aux.GetValueType(v:GetLabelObject())=="Effect" and rc==v:GetLabelObject():GetHandler() then b=true seq,typ=v:GetLabel() end end
			if b and typ and typ~=0 and rc:IsHasEffect(53765098) then
				local e1=Effect.CreateEffect(rc)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetReset(RESET_EVENT+0xfd0000)
				e1:SetValue(typ)
				rc:RegisterEffect(e1,true)
			end
			return ADIMI_MoveToField(rc,...)
		end
		local ADIMI_CreateEffect=Effect.CreateEffect
		function Effect.CreateEffect(rc,...)
			local re=ADIMI_CreateEffect(rc,...)
			ADIMI_EHandler=ADIMI_EHandler or {}
			if re and rc then ADIMI_EHandler[re]=rc end
			return re
		end
		local ADIMI_CRegisterEffect=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			local res=ADIMI_CRegisterEffect(rc,re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if re and res then ADIMI_RegisteredEffects[re]=true end
			return res
		end
		local ADIMI_DRegisterEffect=Duel.RegisterEffect
		Duel.RegisterEffect=function(re,...)
			local res=ADIMI_DRegisterEffect(re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if re and res then ADIMI_RegisteredEffects[re]=true end
			return res
		end
		local ADIMI_IsHasType=Effect.IsHasType
		local ADIMI_GetHandler=Effect.GetHandler
		function Effect.GetHandler(re,...)
			ADIMI_RegisteredEffects=ADIMI_RegisteredEffects or {}
			if ADIMI_IsHasType(re,EFFECT_TYPE_XMATERIAL) and not ADIMI_RegisteredEffects[re] then return ADIMI_EHandler[re] end
			local rc=ADIMI_GetHandler(re,...)
			if not rc then return ADIMI_EHandler[re] end
			return rc
		end
		Effect.IsHasType=function(re,type)
			local res=ADIMI_IsHasType(re,type)
			local rc=ADIMI_GetHandler(re)
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&EFFECT_TYPE_ACTIVATE~=0 then return true else return false end
			else return res end
		end
		local ADIMI_EGetType=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return ADIMI_EGetType(re) end
		end
		local ADIMI_IsActiveType=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=ADIMI_IsActiveType(re,type)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then
				if type&typ~=0 then return true else return false end
			else return res end
		end
		local ADIMI_GetActiveType=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then return typ else return ADIMI_GetActiveType(re) end
		end
		--[[ADIMI_GetActivateLocation=Effect.GetActivateLocation
		Effect.GetActivateLocation=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local ls=0
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>5 then return LOCATION_FZONE elseif ls>0 then return LOCATION_SZONE else return ADIMI_GetActivateLocation(re) end
		end]]--
		local ADIMI_GetActivateSequence=Effect.GetActivateSequence
		Effect.GetActivateSequence=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local ls=0
			local seq=ADIMI_GetActivateSequence(re)
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>0 then return ls-1 else return seq end
		end
		local ADIMI_GetChainInfo=Duel.GetChainInfo
		Duel.GetChainInfo=function(chainc,...)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local b=false
			local ls,typ=0
			if re and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				local xe={}
				if rc then xe={rc:IsHasEffect(53765099)} end
				for _,v in pairs(xe) do
					if re==v:GetLabelObject() then
						b=true
						ls,typ=v:GetLabel()
						break
					end
				end
			end
			local t={ADIMI_GetChainInfo(chainc,...)}
			if b then
				for k,info in ipairs({...}) do
					if info==CHAININFO_TYPE then t[k]=typ end
					if info==CHAININFO_EXTTYPE then t[k]=typ end
					if info==CHAININFO_TRIGGERING_LOCATION then
						if ls>5 then t[k]=LOCATION_FZONE else t[k]=LOCATION_SZONE end
					end
					if info==CHAININFO_TRIGGERING_SEQUENCE and ls>0 then t[k]=ls-1 end
					if info==CHAININFO_TRIGGERING_POSITION then t[k]=POS_FACEUP end
				end
			end
			return table.unpack(t)
		end
		local ADIMI_NegateActivation=Duel.NegateActivation
		Duel.NegateActivation=function(chainc)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local xe={}
			if re and re:GetHandler() then xe={re:GetHandler():IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			local res=ADIMI_NegateActivation(chainc)
			if res and b then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
		local ADIMI_ChangeChainOperation=Duel.ChangeChainOperation
		Duel.ChangeChainOperation=function(chainc,...)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local xe={}
			if re and re:GetHandler() then xe={re:GetHandler():IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then re:GetHandler():CancelToGrave(false) end
			return ADIMI_ChangeChainOperation(chainc,...)
		end
		local ADIMI_IsCanBeEffectTarget=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if c:IsHasEffect(53765098) and cm["Card_Prophecy_Certain_ACST_"..ly] then b=false else b=ADIMI_IsCanBeEffectTarget(sc,...) end
			return b
		end
	end
end
function cm.SpellorTrapSPable(c)
	if not AD_SpellorTrapSPable_Check then
		AD_SpellorTrapSPable_Check=true
		local ADSTSP_IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
		Card.IsCanBeSpecialSummoned=function(sc,se,st,sp,bool1,bool2,spos,stp,sz)
			if st==0 then st=SUMMON_TYPE_SPECIAL end
			if not spos then spos=POS_FACEUP end
			if not stp then stp=sp end
			if not sz then sz=0xff end
			local b=true
			local res=ADSTSP_IsCanBeSpecialSummoned(sc,se,st,sp,bool1,bool2,spos,stp,sz)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) and not sc:IsLocation(LOCATION_MZONE) then
				if sc:IsHasEffect(EFFECT_REVIVE_LIMIT) and not sc:IsStatus(STATUS_PROC_COMPLETE) and not bool1 then b=res end
				local zcheck=false
				for i=0,6 do
					if sz&(1<<i)~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i) then zcheck=true end
					if sz&(1<<(i+16))~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i+16) then zcheck=true end
					if zcheck then break end
				end
				if not zcheck then b=res end
				local sptype,sprace,spatt,splv,spatk,spdef=table.unpack(sc.SSST_Data)
				local e1=Effect.CreateEffect(sc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(sptype|TYPE_MONSTER)
				sc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(sprace)
				sc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(spatt)
				sc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(spatk)
				sc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(spdef)
				sc:RegisterEffect(e5,true)
				local e6=e1:Clone()
				e6:SetCode(EFFECT_CHANGE_LEVEL)
				e6:SetValue(splv)
				sc:RegisterEffect(e6,true)
				if sc:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON) then b=res end
				local re={sc:IsHasEffect(EFFECT_SPSUMMON_COST)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp) then
						local cost=v:GetCost()
						if cost and not cost(v,sc,sp) then b=res end
					end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_CANNOT_SPECIAL_SUMMON)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,st,spos,stp,se) then b=res end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,st,spos,stp,se) then b=res end
				end
				local ct=99
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_SPSUMMON_COUNT_LIMIT)}
				for _,v in pairs(re) do ct=math.min(ct,v:GetValue()) end
				if Duel.GetActivityCount(sp,ACTIVITY_SPSUMMON)>=ct then b=res end
				e1:Reset()
				e2:Reset()
				e3:Reset()
				e4:Reset()
				e5:Reset()
				e6:Reset()
				if ly>0 then cm["Card_Prophecy_Certain_SP_"..ly]=true end
			else b=res end
			return b
		end
		local ADSTSP_SpecialSummon=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,st,sp,stp,bool1,...)
			tg=Group.__add(tg,tg)
			local g=tg:Filter(function(c)return c.initial_effect and c.SpecialSummonableSpellorTrap end,nil)
			if #g>0 then
				bool1=true
				for tc in aux.Next(g) do
					local data=tc.SSST_Data
					tc:AddMonsterAttribute(data[1])
				end
			end
			return ADSTSP_SpecialSummon(tg,st,sp,stp,bool1,...)
		end
		local ADSTSP_SpecialSummonStep=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(tc,st,sp,stp,bool1,...)
			if tc.initial_effect and tc.SpecialSummonableSpellorTrap then
				bool1=true
				local data=tc.SSST_Data
				tc:AddMonsterAttribute(data[1])
			end
			return ADSTSP_SpecialSummonStep(tc,st,sp,stp,bool1,...)
		end
		local ADSTSP_IsType=Card.IsType
		Card.IsType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsType(sc,int) end
			return b
		end
		local ADSTSP_IsSynchroType=Card.IsSynchroType
		Card.IsSynchroType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsSynchroType(sc,int) end
			return b
		end
		local ADSTSP_IsXyzType=Card.IsXyzType
		Card.IsXyzType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsXyzType(sc,int) end
			return b
		end
		local ADSTSP_IsLinkType=Card.IsLinkType
		Card.IsLinkType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsLinkType(sc,int) end
			return b
		end
		local ADSTSP_CGetType=Card.GetType
		Card.GetType=function(sc)
			local b=ADSTSP_CGetType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		local ADSTSP_GetSynchroType=Card.GetSynchroType
		Card.GetSynchroType=function(sc)
			local b=ADSTSP_GetSynchroType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		local ADSTSP_GetXyzType=Card.GetXyzType
		Card.GetXyzType=function(sc)
			local b=ADSTSP_GetXyzType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		local ADSTSP_GetLinkType=Card.GetLinkType
		Card.GetLinkType=function(sc)
			local b=ADSTSP_GetLinkType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		local ADSTSP_IsRace=Card.IsRace
		Card.IsRace=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[2]~=0) else b=ADSTSP_IsRace(sc,int) end
			return b
		end
		local ADSTSP_GetRace=Card.GetRace
		Card.GetRace=function(sc)
			local b=ADSTSP_GetRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		local ADSTSP_GetOriginalRace=Card.GetOriginalRace
		Card.GetOriginalRace=function(sc)
			local b=ADSTSP_GetOriginalRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		local ADSTSP_GetLinkRace=Card.GetLinkRace
		Card.GetLinkRace=function(sc)
			local b=ADSTSP_GetLinkRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		local ADSTSP_IsAttribute=Card.IsAttribute
		Card.IsAttribute=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[3]~=0) else b=ADSTSP_IsAttribute(sc,int) end
			return b
		end
		local ADSTSP_IsNonAttribute=Card.IsNonAttribute
		Card.IsNonAttribute=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[3]==0) else b=ADSTSP_IsNonAttribute(sc,int) end
			return b
		end
		local ADSTSP_GetAttribute=Card.GetAttribute
		Card.GetAttribute=function(sc)
			local b=ADSTSP_GetAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		local ADSTSP_GetOriginalAttribute=Card.GetOriginalAttribute
		Card.GetOriginalAttribute=function(sc)
			local b=ADSTSP_GetOriginalAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		local ADSTSP_GetLinkAttribute=Card.GetLinkAttribute
		Card.GetLinkAttribute=function(sc)
			local b=ADSTSP_GetLinkAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		local ADSTSP_IsLevel=Card.IsLevel
		Card.IsLevel=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[4]) else b=ADSTSP_IsLevel(sc,int,...) end
			return b
		end
		local ADSTSP_IsLevelAbove=Card.IsLevelAbove
		Card.IsLevelAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[4]) else b=ADSTSP_IsLevelAbove(sc,int) end
			return b
		end
		local ADSTSP_IsLevelBelow=Card.IsLevelBelow
		Card.IsLevelBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[4]) else b=ADSTSP_IsLevelBelow(sc,int) end
			return b
		end
		local ADSTSP_GetLevel=Card.GetLevel
		Card.GetLevel=function(sc)
			local b=ADSTSP_GetLevel(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[4] end
			return b
		end
		local ADSTSP_GetOriginalLevel=Card.GetOriginalLevel
		Card.GetOriginalLevel=function(sc)
			local b=ADSTSP_GetOriginalLevel(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[4] end
			return b
		end
		local ADSTSP_IsAttack=Card.IsAttack
		Card.IsAttack=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[5]) else b=ADSTSP_IsAttack(sc,int,...) end
			return b
		end
		local ADSTSP_IsAttackAbove=Card.IsAttackAbove
		Card.IsAttackAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[5]) else b=ADSTSP_IsAttackAbove(sc,int) end
			return b
		end
		local ADSTSP_IsAttackBelow=Card.IsAttackBelow
		Card.IsAttackBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[5]) else b=ADSTSP_IsAttackBelow(sc,int) end
			return b
		end
		local ADSTSP_GetAttack=Card.GetAttack
		Card.GetAttack=function(sc)
			local b=ADSTSP_GetAttack(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[5] end
			return b
		end
		local ADSTSP_GetBaseAttack=Card.GetBaseAttack
		Card.GetBaseAttack=function(sc)
			local b=ADSTSP_GetBaseAttack(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[5] end
			return b
		end
		local ADSTSP_IsDefense=Card.IsDefense
		Card.IsDefense=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[6]) else b=ADSTSP_IsDefense(sc,int,...) end
			return b
		end
		local ADSTSP_IsDefenseAbove=Card.IsDefenseAbove
		Card.IsDefenseAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[6]) else b=ADSTSP_IsDefenseAbove(sc,int) end
			return b
		end
		local ADSTSP_IsDefenseBelow=Card.IsDefenseBelow
		Card.IsDefenseBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[6]) else b=ADSTSP_IsDefenseBelow(sc,int) end
			return b
		end
		local ADSTSP_GetDefense=Card.GetDefense
		Card.GetDefense=function(sc)
			local b=ADSTSP_GetDefense(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[6] end
			return b
		end
		local ADSTSP_GetBaseDefense=Card.GetBaseDefense
		Card.GetBaseDefense=function(sc)
			local b=ADSTSP_GetBaseDefense(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[6] end
			return b
		end
		local ADSTSP_IsCanBeEffectTarget=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if sc.initial_effect and sc.SpecialSummonableSpellorTrap and cm["Card_Prophecy_Certain_SP_"..ly] then b=res else b=ADSTSP_IsCanBeEffectTarget(sc,...) end
			return b
		end
	end
end
function cm.HelltakerActivate(c,code)
	cm.AozoraDisZoneGet(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(53765000)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(53765000)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EVENT_MOVE)
	ex:SetOperation(cm.HTAmvhint(code))
	c:RegisterEffect(ex)
	if not AD_Helltaker_Check then
		AD_Helltaker_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.HTAmvop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ADHT_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(sc,mp,tp,dest,pos,bool,zone)
			local czone=zone or 0xff
			if ad_ht_fr then czone=ad_ht_fr end
			return ADHT_MoveToField(sc,mp,tp,dest,pos,bool,czone)
		end
		local ADHT_GetLocationCount=Duel.GetLocationCount
		Duel.GetLocationCount=function(...)
			local ct=ADHT_GetLocationCount(...)+ad_ht_zc
			return ct
		end
	end
end
ad_ht_zc=0
function cm.HTAfactarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
AD_Given_Effect={}
function cm.HTAmvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD,0,nil,STATUS_CHAINING)
	for c in aux.Next(g) do
		local rse={c:IsHasEffect(53765050)}
		for _,v in pairs(rse) do
			if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	if not Duel.IsPlayerAffectedByEffect(tp,53765000) then return end
	g=Duel.GetMatchingGroup(function(c)return c:GetActivateEffect() and not c:GetActivateEffect():IsActiveType(TYPE_FIELD)end,tp,LOCATION_HAND,0,nil)
	for c in aux.Next(g) do
		local le={c:GetActivateEffect()}
		for _,te in pairs(le) do
			local ale=nil
			local rse={c:IsHasEffect(53765097)}
			for k,v in pairs(rse) do
				if te==v:GetLabelObject() and k<#rse then
					ale=rse[k+1]
					ale=ale:GetLabelObject()
					break
				end
			end
			if ale then
				if te:GetCategory()~=ale:GetCategory() then ale:SetCategory(te:GetCategory()) end
				local tecon=te:GetCondition() or aux.TRUE
				local alecon=ale:GetCondition() or aux.TRUE
				if tecon~=alecon then ale:SetCondition(tecon) end
				local tecost=te:GetCost() or aux.TRUE
				local alecost=ale:GetCost() or aux.TRUE
				if tecost~=alecost then ale:SetCost(tecost) end
				local tetg=te:GetTarget() or aux.TRUE
				local aletg=ale:GetTarget() or aux.TRUE
				if tetg~=aletg then ale:SetTarget(tetg) end
				if te:GetOperation()~=ale:GetOperation() then ale:SetOperation(te:GetOperation()) end
				if te:GetLabel()~=ale:GetLabel() then ale:SetLabel(te:GetLabel()) end
				if te:GetValue()~=ale:GetValue() then ale:SetValue(te:GetValue()) end
			elseif te:GetRange()&0x2~=0 then
				local e1=te:Clone()
				e1:SetDescription(aux.Stringid(53765000,14))
				if te:GetCode()==EVENT_FREE_CHAIN then
					if te:IsActiveType(TYPE_TRAP+TYPE_QUICKPLAY) then e1:SetType(EFFECT_TYPE_QUICK_O) else e1:SetType(EFFECT_TYPE_IGNITION) end
				elseif te:GetCode()==EVENT_CHAINING and te:GetProperty()&EFFECT_FLAG_DELAY==0 then
					if ADIMI_EGetType(te)&EFFECT_TYPE_QUICK_F~=0 then e1:SetType(EFFECT_TYPE_QUICK_F) else e1:SetType(EFFECT_TYPE_QUICK_O) end
				elseif te:GetCode()~=0 then
					if ADIMI_EGetType(te)&EFFECT_TYPE_TRIGGER_F~=0 then e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) else e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) end
				else e1:SetType(EFFECT_TYPE_IGNITION) end
				e1:SetRange(LOCATION_HAND)
				local pro,pro2=te:GetProperty()
				e1:SetProperty(pro|EFFECT_FLAG_UNCOPYABLE,pro2)
				e1:SetReset(RESET_EVENT+0xff0000)
				c:RegisterEffect(e1,true)
				--table.insert(AD_Given_Effect,e1)
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" then val=aux.TRUE end
					v:SetValue(cm.AASTbchval(val,e1))
				end
				local zone=0xff
				if te:IsActiveType(TYPE_PENDULUM) then zone=0x11 end
				if te:IsHasProperty(EFFECT_FLAG_LIMIT_ZONE) then
					zone=te:GetValue()
					if aux.GetValueType(zone)=="function" then zone=zone(te,tp,eg,ep,ev,re,r,rp) end
				end
				local fcheck=false
				local fe={Duel.IsPlayerAffectedByEffect(0,53765050)}
				for _,v in pairs(fe) do
					local ae=v:GetLabelObject()
					if ae:GetLabelObject() and ae:GetLabelObject()==te and ae:GetCode() and ae:GetCode()==EFFECT_ACTIVATE_COST and ae:GetRange()&LOCATION_HAND~=0 then
						fcheck=true
						local e2_1=ae:Clone()
						if ae:GetRange()==0 then
							local lbrange=ae:GetLabel()
							if lbrange==0 then lbrange=0xff end
							e2_1:SetRange(lbrange)
						end
						e2_1:SetLabelObject(e1)
						e2_1:SetTarget(cm.HTAfactarget)
						local cost=ae:GetCost()
						if not cost then cost=aux.TRUE end
						e2_1:SetCost(cm.HTAfaccost(cost,te,zone))
						local op=ae:GetOperation()
						e2_1:SetOperation(cm.HTAfcostop(op,zone))
						e2_1:SetReset(RESET_EVENT+0xff0000)
						c:RegisterEffect(e2_1,true)
						local e3_1=Effect.CreateEffect(c)
						e3_1:SetType(EFFECT_TYPE_SINGLE)
						e3_1:SetCode(53765050)
						e3_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e3_1:SetLabelObject(e2_1)
						e3_1:SetReset(RESET_EVENT+0xff0000)
						c:RegisterEffect(e3_1,true)
					end
				end
				if not fcheck then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_ACTIVATE_COST)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetRange(LOCATION_HAND)
					e2:SetTargetRange(1,0)
					e2:SetTarget(cm.HTAfactarget)
					e2:SetCost(cm.HTAfaccost(aux.TRUE,te,zone))
					e2:SetOperation(cm.HTAfcostop(cm.HTAmvcostop,zone))
					e2:SetLabelObject(e1)
					e2:SetReset(RESET_EVENT+0xff0000)
					c:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(53765050)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetLabelObject(e2)
					e3:SetReset(RESET_EVENT+0xff0000)
					c:RegisterEffect(e3,true)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(53765097)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e4:SetLabelObject(te)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e4,true)
				local e5=e4:Clone()
				e5:SetLabelObject(e1)
				c:RegisterEffect(e5,true)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e6:SetCode(EVENT_CHAIN_SOLVING)
				e6:SetCountLimit(1)
				e6:SetLabelObject(e1)
				e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return re==e:GetLabelObject()end)
				e6:SetOperation(cm.HTArsop)
				Duel.RegisterEffect(e6,tp)
				local e7=e6:Clone()
				e7:SetCode(EVENT_CHAIN_NEGATED)
				Duel.RegisterEffect(e7,tp)
			end
		end
	end
end
function cm.HTArsop(e,tp,eg,ep,ev,re,r,rp)
	local rse={re:GetHandler():IsHasEffect(53765050)}
	for _,v in pairs(rse) do
		if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
		if v:GetLabelObject() then v:GetLabelObject():Reset() end
		v:Reset()
	end
	e:Reset()
end
function cm.HTAfaccost(_cost,fe,zone)
	return function(e,te,tp)
				ad_ht_zc=1
				local fcost=fe:GetCost()
				local ftg=fe:GetTarget()
				local check=false
				local code=fe:GetCode()
				if code==0 or code==EVENT_FREE_CHAIN then
					if (not fcost or fcost(fe,tp,nil,0,0,nil,0,0,0)) and (not ftg or ftg(fe,tp,nil,0,0,nil,0,0,0)) then check=true end
				else
					local cres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
					if (not fcost or fcost(fe,tp,teg,tep,tev,tre,tr,trp,0)) and (not ftg or ftg(fe,tp,teg,tep,tev,tre,tr,trp,0)) then check=true end
				end
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" or val(v,fe,tp) then check=false end
				end
				if not check then
					ad_ht_zc=0
					return false
				end
				ad_ht_zc=0
				local c=e:GetHandler()
				local xe={c:IsHasEffect(53765099)}
				for _,v in pairs(xe) do v:Reset() end
				if te:IsActiveType(TYPE_QUICKPLAY) and Duel.GetTurnPlayer()~=tp and not c:IsHasEffect(EFFECT_QP_ACT_IN_NTPHAND) then return false end
				if te:IsActiveType(TYPE_TRAP) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) then return false end
				if not c:CheckUniqueOnField(tp) then return false end
				ad_ht_zc=1
				if not Duel.IsExistingMatchingCard(cm.HTAmvfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,zone) then
					ad_ht_zc=0
					return false
				end
				local res=false
				if _cost(e,te,tp) then res=true end
				ad_ht_zc=0
				--Debug.Message(res)
				return res
			end
end
function cm.HTAfcostop(_op,zone)
	return function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53765000,15))
				local tc=Duel.SelectMatchingCard(tp,cm.HTAmvfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,zone):GetFirst()
				local seq=tc:GetSequence()
				if seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then Duel.MoveSequence(tc,seq-1) else Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,1<<seq) end
				ad_ht_fr=1<<seq
				_op(e,tp,teg,tep,tev,tre,tr,trp)
				ad_ht_fr=nil
			end
end
function cm.HTAmvfilter(c,e,tp,zone)
	local seq=c:GetSequence()
	return c:IsHasEffect(53765000) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,1<<seq)) and (1<<seq)&zone~=0 and cm.RinnaZone(tp,Group.FromCards(c),true)>0
end
function cm.HTAmvcostop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local typ=c:GetType()
	if te:IsActiveType(TYPE_PENDULUM) then typ=TYPE_PENDULUM+TYPE_SPELL end
	local xe1=cm.AASTregi(c,te)
	if typ==TYPE_PENDULUM+TYPE_SPELL then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetCode(EFFECT_CHANGE_TYPE)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e0:SetValue(typ)
		c:RegisterEffect(e0,true)
	else Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false) end
	xe1:SetLabel(c:GetSequence()+1,typ)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.HTAmvrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	ad_ht_fr=nil
end
function cm.HTAmvrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	if re then re:Reset() end
end
function cm.HTAmvhint(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler())) then return end
	local flag=c:GetFlagEffectLabel(code+50)
	if flag then
		flag=flag+1
		c:ResetFlagEffect(code+50)
		local hflag=flag-1
		if hflag>13 then hflag=13 end
		c:RegisterFlagEffect(code+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(53765000,hflag))
	else c:RegisterFlagEffect(code+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(53765000,0)) end
	end
end
function cm.DragoronMergedDelay(c)
	local mt=getmetatable(c)
	if mt[53757098]==true then return end
	mt[53757098]=true
	if not g then g=Group.CreateGroup() end
	g:KeepAlive()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_SOLVING)
	ge1:SetLabelObject(g)
	ge1:SetOperation(cm.DragoronM1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(4179255)
	ge2:SetOperation(cm.DragoronM2)
	Duel.RegisterEffect(ge2,0)
	local ge3=ge1:Clone()
	ge3:SetCode(EVENT_CHAIN_END)
	ge3:SetOperation(cm.DragoronMEnd)
	Duel.RegisterEffect(ge3,0)
end
function cm.DragoronM1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) then g:Merge(re:GetHandler()) end
end
function cm.DragoronM2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if re then g:Merge(re:GetHandler()) end
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+53757098,re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.DragoronMEnd(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+53757098,re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.DragoronActivate(c,code)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetSequence()<5 end)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e1)
	e3:SetTarget(cm.ADGDactarget)
	e3:SetOperation(cm.ADGDcostop)
	Duel.RegisterEffect(e3,0)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetLabelObject(c)
	e5:SetTarget(cm.ADGDreptarget)
	e5:SetValue(cm.ADGDrepval)
	e5:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e5,0)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(1,1)
	e6:SetLabelObject(c)
	e6:SetTarget(cm.ADGDactarget2)
	e6:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e6,0)
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_FIELD)
	e6_1:SetCode(EFFECT_SSET_COST)
	e6_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6_1:SetTargetRange(0xff,0xff)
	e6_1:SetLabelObject(c)
	e6_1:SetTarget(cm.ADGDactarget3)
	e6_1:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e6_1,0)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(53757000)
	e8:SetLabelObject(e1)
	e8:SetCondition(function(e)
		return e:GetHandler():IsLocation(LOCATION_SZONE)
	end)
	c:RegisterEffect(e8)
	if not Goron_Dimension_Check then
		Goron_Dimension_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.ADGDaccon)
		ge1:SetOperation(cm.ADGDacop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCondition(aux.TRUE)
		ge2:SetCode(4179255)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_MOVE)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,nil)
			g:ForEach(Card.ResetFlagEffect,53757050)
		end)
		Duel.RegisterEffect(ge3,0)
		local ADGD_SSet=Duel.SSet
		Duel.SSet=function(tp,tg,tgp,...)
			Dragoron_SSet_Check=true
			if not tgp then tgp=tp end
			tg=Group.__add(tg,tg)
			if tg:IsExists(Card.IsType,1,nil,TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tgp,LOCATION_FZONE,0)
				if fc and fc:IsHasEffect(53757000) and Duel.GetLocationCount(tgp,LOCATION_SZONE)-tg:FilterCount(aux.NOT(Card.IsType),nil,TYPE_FIELD)>0 then
					Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(tgp,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
				end
			end
			local ct=ADGD_SSet(tp,tg,tgp,...)
			Dragoron_SSet_Check=false
			return ct
		end
		local ADGD_SendtoGrave=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoGrave(tg,reason)
		end
		local ADGD_Destroy=Duel.Destroy
		Duel.Destroy=function(tg,reason,...)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_Destroy(tg,reason,...)
		end
		local ADGD_DRemove=Duel.Remove
		Duel.Remove=function(tg,pos,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_DRemove(tg,pos,reason)
		end
		local ADGD_SendtoHand=Duel.SendtoHand
		Duel.SendtoHand=function(tg,tp,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoHand(tg,tp,reason)
		end
		local ADGD_SendtoDeck=Duel.SendtoDeck
		Duel.SendtoDeck=function(tg,tp,seq,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoDeck(tg,tp,seq,reason)
		end
		local ADGD_SetReset=Effect.SetReset
		Effect.SetReset=function(re,reset,...)
			if reset&RESET_TOFIELD~=0 then Dragoron_Reset_Check=true end
			return ADGD_SetReset(re,reset,...)
		end
		local ADGD_CRegisterEffect=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			if Dragoron_Reset_Check then
				local e1=Effect.CreateEffect(rc)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_MOVE)
				e1:SetLabelObject(re)
				e1:SetCondition(cm.ADGDresetcon)
				e1:SetOperation(cm.ADGDresetop)
				Duel.RegisterEffect(e1,rp)
				Dragoron_Reset_Check=false
			end
			if re and re:GetCode()==117 and rc:GetType()==re:GetValue() then return end
			return ADGD_CRegisterEffect(rc,re,...)
		end
		local ADGD_DRegisterEffect=Duel.RegisterEffect
		Duel.RegisterEffect=function(...)
			Dragoron_Reset_Check=false
			return ADGD_DRegisterEffect(...)
		end
		local ADGD_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(mc,p,tgp,dest,...)
			mc:ResetFlagEffect(53757050)
			local res=ADGD_MoveToField(mc,p,tgp,dest,...)
			if dest==LOCATION_FZONE then mc:RegisterFlagEffect(53757050,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) end
			if dest==LOCATION_SZONE and mc:IsHasEffect(53757000) then cm.ADGDTypeChange(mc) end
			return res
		end
		local ADGD_MoveSequence=Duel.MoveSequence
		Duel.MoveSequence=function(mc,seq)
			mc:ResetFlagEffect(53757050)
			return ADGD_MoveSequence(mc,seq)
		end
		local ADGD_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local re=ADGD_GetActivateEffect(ac)
			local le={ac:IsHasEffect(53757000)}
			if #le>0 and not ac:IsLocation(LOCATION_FZONE) then
				le=le[1]
				re=le:GetLabelObject()
			end
			return re
		end
		local ADGD_GetOriginalType=Card.GetOriginalType
		Card.GetOriginalType=function(ac)
			if ac:IsHasEffect(53757000) then return 0x80002 else return ADGD_GetOriginalType(ac) end
		end
	end
	return e0,e1,e3,e5,e6,e6_1
end
function cm.ADGDresetfil(c,tc)
	return c==tc and ((c:IsPreviousLocation(LOCATION_FZONE) and not c:IsLocation(LOCATION_FZONE)) or (c:IsLocation(LOCATION_FZONE) and not c:IsPreviousLocation(LOCATION_FZONE)))
end
function cm.ADGDresetcon(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	if not re or aux.GetValueType(re)~="Effect" then
		e:Reset()
		return false
	end
	return eg:IsExists(cm.ADGDresetfil,1,nil,re:GetHandler())
end
function cm.ADGDresetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.ADGDaccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.ADGDacop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,53757050)>0 then return end
	if Duel.GetCurrentChain()>0 then Duel.RegisterFlagEffect(rp,53757050,RESET_CHAIN,0,1) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetLabelObject(re)
	e1:SetOperation(cm.ADGDregop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,rp)
end
function cm.ADGDregop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then Duel.RaiseSingleEvent(fc,EVENT_CUSTOM+53757099,e:GetLabelObject(),0,tp,tp,e:GetLabel()) end
	e:Reset()
end
function cm.ADGDrepfilter(c,tc)
	return c==tc and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0 and c:IsLocation(LOCATION_FZONE)
end
function cm.ADGDreptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then return eg:IsExists(cm.ADGDrepfilter,1,nil,c) end
	return true
end
function cm.ADGDrepval(e,c)
	return cm.ADGDrepfilter(c,e:GetLabelObject())
end
function cm.ADGDTypeChange(c)
	c:SetCardData(CARDDATA_TYPE,0x20002)
	local t={}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():GetSequence()<5 then return end
		e:GetHandler():SetCardData(4,0x80002)
		for k,v in pairs(t) do v:Reset() end
	end)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():GetSequence()<5 end)
	c:RegisterEffect(e2,true)
	t={e1,e2}
end
function cm.ADGDrepoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c:IsLocation(LOCATION_FZONE) then return end
	local p=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
	local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
	Duel.MoveSequence(c,math.log(mv,2)-8)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	cm.ADGDTypeChange(c)
end
function cm.ADGDactarget2(e,te,tp)
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return c:IsLocation(LOCATION_FZONE) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 and te:IsActiveType(TYPE_FIELD) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsControler(p) and p==tp and te:GetHandler()~=c
end
function cm.ADGDactarget3(e,tc,tp)
	if Dragoron_SSet_Check then return false end
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return c:IsLocation(LOCATION_FZONE) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 and tc:IsType(TYPE_FIELD) and c:IsControler(p) and tc:GetControler()==p and tc~=c
end
function cm.ADGDactarget(e,te,tp)
	local ce=e:GetLabelObject()
	return te:GetHandler()==e:GetOwner() and te==ce and ce:GetHandler():IsLocation(LOCATION_SZONE) and ce:GetHandler():GetSequence()<5
end
function cm.ADGDcostop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local p=te:GetHandlerPlayer()
	local c=te:GetHandler()
	local fc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
	if fc then Duel.SendtoGrave(fc,REASON_RULE) end
	Duel.MoveSequence(c,5)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	c:SetStatus(STATUS_EFFECT_ENABLED,false)
	c:CreateEffectRelation(te)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.ADGDrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,p)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,p)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
end
function cm.ADGDrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabelObject(re)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetLabelObject():GetHandler():IsLocation(LOCATION_FZONE) then
			e:GetLabelObject():SetType(EFFECT_TYPE_IGNITION)
			e:Reset()
		end
	end)
	Duel.RegisterEffect(e1,tp)
	e:Reset()
end
function cm.GoronDimensionCopy(c,cd,tab)
	local cat,type,code,cost,con,tg,op,pro1,pro2=table.unpack(tab)
	if type&EFFECT_TYPE_SINGLE~=0 then return end
	if type&(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)~=0 and code and code==EVENT_CHAINING then return end
	if not con then con=aux.TRUE end
	if not cost then cost=aux.TRUE end
	if not tg then tg=aux.TRUE end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+53757099)
	e0:SetRange(0xff)
	e0:SetCountLimit(1)
	e0:SetOperation(cm.ADGDtrop(cd))
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(cd,1))
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+cd)
	e1:SetRange(0xff)
	e1:SetProperty(pro1|EFFECT_FLAG_DELAY,pro2)
	e1:SetCountLimit(1)
	if type&EFFECT_TYPE_IGNITION==0 and code and code~=EVENT_FREE_CHAIN and code~=EVENT_CHAINING then
		e1:SetCondition(cm.ADGDrecon(con,cd))
		e1:SetCost(cm.ADGDrecost(cost,cd))
		e1:SetTarget(cm.ADGDretg(tg,op,cd))
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(code)
		e3:SetLabelObject(g)
		e3:SetOperation(cm.ADGDMergedDelayEventCheck1(cd))
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		e4:SetCode(EVENT_CHAIN_END)
		e4:SetOperation(cm.ADGDMergedDelayEventCheck2(cd))
		Duel.RegisterEffect(e4,0)
	else
		e1:SetCondition(con)
		e1:SetCost(cost)
		e1:SetTarget(tg)
		e1:SetOperation(op)
	end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.ADGDtrop(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_FZONE) then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+cd,re,0,rp,ep,ev)
	e:Reset()
	end
end
function cm.ADGDrecon(_con,cd)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				return _con(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDrecost(_cost,cd)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				return _cost(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDretg(_tg,_op,cd)
	return function(e,tp,eg,ep,ev,re,r,rp,...)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				e:SetOperation(cm.ADGDreop(_op,teg,tep,tev,tre,tr,trp))
				return _tg(e,tp,teg,tep,tev,tre,tr,trp,...)
			end
end
function cm.ADGDreop(_op,teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				_op(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDMergedDelayEventCheck1(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(cd+50),re,r,rp,ep,ev)
		g:Clear()
	end
	end
end
function cm.ADGDMergedDelayEventCheck2(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(cd+50),re,r,rp,ep,ev)
		g:Clear()
	end
	end
end
function cm.Select_1(g,tp,msg)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,msg)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	return tc
end
function cm.Act(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.HTAfactarget)
	e1:SetOperation(cm.BaseActOp)
	return e1
end
function cm.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.BaseActReset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.BaseActReset(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
end
function cm.AdvancedActOp(ctype,op)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local typ=c:GetType()
	if te:IsActiveType(TYPE_PENDULUM) then typ=TYPE_PENDULUM+TYPE_SPELL end
	local xe1=cm.AASTregi(c,te)
	if ctype&0x80000~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
			Duel.ChangePosition(c,POS_FACEUP)
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
		elseif not c:IsLocation(LOCATION_SZONE) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		end
	end
	xe1:SetLabel(c:GetSequence()+1,typ)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.BaseActReset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	end
end
function cm.Excavated_Check(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCondition(cm.DimpthoxEregcon)
	e0:SetOperation(cm.DimpthoxEregop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(53766099)
	e1:SetRange(LOCATION_DECK)
	c:RegisterEffect(e1)
	if Dimpthox_Excavated_Check then return end
	Dimpthox_Excavated_Check=true
	local ge=Effect.GlobalEffect()
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_ADJUST)
	ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)Dimpthox_E_Check=false end)
	Duel.RegisterEffect(ge,tp)
	local f=Duel.ConfirmDecktop
	Duel.ConfirmDecktop=function(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:IsExists(Card.IsHasEffect,1,nil,53766099) then Dimpthox_E_Check=true end
		return f(tp,ct)
	end
end
function cm.DimpthoxExCostFil(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(53766027,tp)
end
function cm.Dimpthox_Grave_Trap_Eff_Cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.DimpthoxExCostFil,tp,LOCATION_GRAVE,0,nil,tp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() or #g>0 end
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(53766027,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local te=tc:IsHasEffect(53766027,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end
function cm.DimpthoxEregcon(e,tp,eg,ep,ev,re,r,rp)
	return Dimpthox_E_Check
end
function cm.DimpthoxEregop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(53766099,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
function cm.GetCurrentPhase()
	local ph=Duel.GetCurrentPhase()
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then ph=PHASE_BATTLE end
	return ph
end
function cm.Not_Destroyed_Count(c)
	local flag=c:GetFlagEffectLabel(53766008) or 0
	if flag<15 and c:IsLocation(LOCATION_ONFIELD) then
		flag=flag+1
		c:ResetFlagEffect(53766008)
		c:RegisterFlagEffect(53766008,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(53766008,flag))
	end
end
function cm.Not_Destroyed_Check(c)
	if Dimpthox_Not_Destroyed_Check then return end
	Dimpthox_Not_Destroyed_Check=true
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(cm.DimpthoxDcheckop)
	Duel.RegisterEffect(ge1,0)
	local _Destroy=Duel.Destroy
	Duel.Destroy=function(g,rs,...)
		local ct=_Destroy(g,rs,...)
		if rs&0x60~=0 then Group.__add(g,g):ForEach(cm.Not_Destroyed_Count) Duel.RaiseEvent(Group.__add(g,g):Filter(Card.IsLocation,nil,LOCATION_MZONE),EVENT_CUSTOM+53766016,Effect.GlobalEffect(),0,0,0,0) end
		return ct
	end
end
cm.ndc_0=nil
cm.ndc_1=nil
cm.ndc_2=0
function cm.DimpthoxDcheckop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL) or Duel.GetFlagEffect(0,53766098)>0 then return end
	cm.ndc_0=Duel.GetAttacker()
	cm.ndc_1=Duel.GetAttackTarget()
	if not cm.ndc_0 or not cm.ndc_1 then return end
	local at,bt=cm.ndc_0,cm.ndc_1
	if Duel.IsDamageCalculated() then
		if cm.ndc_2~=3 then
			local g=Group.CreateGroup()
			if cm.ndc_2~=0 then cm.Not_Destroyed_Count(at) g:AddCard(at) end
			if cm.ndc_2~=1 then cm.Not_Destroyed_Count(bt) g:AddCard(bt) end
			Duel.RaiseEvent(g:Filter(aux.NOT(Card.IsStatus),nil,STATUS_BATTLE_RESULT),EVENT_CUSTOM+53766016,Effect.GlobalEffect(),0,0,0,0)
		end
		Duel.RegisterFlagEffect(0,53766098,RESET_PHASE+PHASE_DAMAGE,0,1)
	else
		local getatk=function(c)
			local sete={c:IsHasEffect(EFFECT_SET_BATTLE_ATTACK)}
			local val=c:GetAttack()
			if #sete>0 then
				sete=sete[#sete]
				val=sete:GetValue()
				if aux.GetValueType(val)=="function" then val=val(e) end
			end
			return val
		end
		local getdef=function(c)
			local sete={c:IsHasEffect(EFFECT_SET_BATTLE_DEFENSE)}
			local val=c:GetDefense()
			if #sete>0 then
				sete=sete[#sete]
				val=sete:GetValue()
				if aux.GetValueType(val)=="function" then val=val(e) end
			end
			return val
		end
		local atk=getatk(at)
		local le={at:IsHasEffect(EFFECT_DEFENSE_ATTACK)}
		local val=0
		for _,v in pairs(le) do
			val=v:GetValue()
			if aux.GetValueType(val)=="function" then val=val(e) end
		end
		if val==1 then
			atk=getdef(at)
		end
		if bt:IsAttackPos() then
			if atk>getatk(bt) then cm.ndc_2=0 elseif getatk(bt)>atk then cm.ndc_2=1 else cm.ndc_2=2 end
		elseif atk>getdef(bt) then cm.ndc_2=0 else cm.ndc_2=3 end
	end
end
function cm.GetFlagEffectLabel(c,code)
	return c:GetFlagEffectLabel(code) or 0
end
function cm.ATTSeries(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53796175,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.ATTSeriescondition)
	e1:SetTarget(cm.ATTSeriestarget)
	e1:SetOperation(cm.ATTSeriesoperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.ATTSeriescondition(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	if tc==e:GetHandler() or tc:IsFacedown() or tc:IsSummonPlayer(tp) then return false end
	e:SetLabel(tc:GetAttribute())
	return true
end
function cm.ATTSeriesfilter(c,e,tp,att)
	return c:IsAttribute(att) and c:IsLevel(4) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ATTSeriestarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.ATTSeriesfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.ATTSeriesoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.ATTSeriesfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.ATTSerieslockcon(n,att)
	return  function(e)
				return Duel.IsExistingMatchingCard(function(c,att)return c:IsFaceup() and c:IsAttribute(att)end,math.abs(e:GetHandlerPlayer()-n),LOCATION_MZONE,0,1,nil,att)
			end
end
function cm.AozoraDisZoneGet(c)
	Adzg_cid=_G["c"..c:GetOriginalCode()]
	if not AozoraDisZoneGet_Check then
		AozoraDisZoneGet_Check=true
		local temp1=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			temp1(e,p)
		end
		local temp2=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),0,0
				if e:GetRange() then range=e:GetRange() end
				if e:GetCondition() then con=e:GetCondition() end
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					temp2(c,ex)
					Adzg_cid[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			temp2(c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(53734098)>0 then return end
	c:RegisterFlagEffect(53734098,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=Adzg_cid[e][1],Adzg_cid[e][2],Adzg_cid[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.BoLiuTuiMi(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.bltmadjustcon)
	e1:SetOperation(cm.bltmadjustop)
	c:RegisterEffect(e1)
end
function cm.bltmthfilter(c)
	return c:GetType()&0x82==0x82
end
function cm.bltmadjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.bltmthfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.bltmadjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.bltmthfilter,tp,LOCATION_DECK,0,nil)
	local c=e:GetHandler()
	if #g==0 or not c:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local seqc=c:GetSequence()
	local seqtc=tc:GetSequence()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=0
	if seqtc+1<=ct/2 then seq=1 end
	local mg=Duel.GetMatchingGroup(function(c,b,s)return (b and c:GetSequence()>s) or (not b and c:GetSequence()<s)end,tp,LOCATION_DECK,0,nil,seq==0,seqtc)
	Duel.DisableShuffleCheck()
	Duel.SendtoHand(tc,tp,REASON_RULE)
	Duel.SendtoDeck(c,tp,seq,REASON_RULE)
	if seq==0 then for tc in aux.Next(mg) do Duel.MoveSequence(tc,0) end else
		while #mg>0 do
			local mtc=nil
			local chc=mg:GetFirst()
			while chc do
				mtc=chc
				chc=mg:GetNext()
			end
			Duel.MoveSequence(mtc,1)
			mg:RemoveCard(mtc)
		end
	end
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
--Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
end
function cm.IsActivatable(e,p)
	local check=true
	if e:GetHandler():IsHasEffect(EFFECT_CANNOT_TRIGGER) then check=false end
	local p=e:GetHandlerPlayer()
	local le1={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,e,p) then check=false end
	end
	local le2={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	for _,v in pairs(le2) do
		local cost=v:GetCost()
		if cost and not cost(v,e,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,e,p) then check=false end
		end
	end
	return check
end
function cm.WhitkinsToGrave(g,reason)
	local out=Group.CreateGroup()
	if Duel.SendtoGrave(g,reason)~=0 then
		out=Duel.GetOperatedGroup()
		local og=out:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local tp=Duel.GetTurnPlayer()
		local x=(tp==0 and 1) or -1
		for p=tp,1-tp,x do
			local sg=Group.CreateGroup()
			cm[201]={}
			local ct=0
			local mg=og:Filter(Card.IsControler,nil,p)
			local gct=mg:GetCount()
			if gct>1 then
				while true do
					if #mg==0 then break end
					Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(53767028,15))
					local sc=mg:SelectUnselect(sg,p,true,#sg>0,#mg,gct)
					if not sc then break elseif mg:IsContains(sc) then
						mg:RemoveCard(sc)
						sg:AddCard(sc)
						ct=ct+1
						cm[201][sc]=ct
					else
						sg:RemoveCard(sc)
						mg:AddCard(sc)
						cm[201][sc]=nil
					end
				end
				for i=ct,0,-1 do
					for tc in aux.Next(sg) do
						if cm[201][tc]==i then Duel.MoveSequence(tc,0) end
					end
				end
			end
			cm[201]={}
		end
	end
	return out
end
function cm.Whitkins(c,id,att)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.Whitkinssdtg)
	e2:SetOperation(cm.Whitkinssdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.Whitkinsfstg)
	e3:SetOperation(cm.Whitkinsfsop(id,att))
	c:RegisterEffect(e3)
end
function cm.Whitkinssdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.Whitkinssdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function cm.WhitkinsGetSequenceMinus(c,seq)
	return math.abs(c:GetSequence()-seq)
end
function cm.Whitkinsfilter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget(e)
end
function cm.Whitkinsmfilter(c,tseq,seq,e)
	local res=false
	local cseq=c:GetSequence()
	return cseq>math.min(tseq,seq) and cseq<math.max(tseq,seq) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and (not e or not c:IsImmuneToEffect(e))
end
function cm.Whitkinsffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_INSECT) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.Whitkinsfilter2(c,e,tp,seq)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.Whitkinsmfilter,tp,LOCATION_GRAVE,0,nil,c:GetSequence(),seq,nil)
	local le=cm.Whitkinsmust(e,mg1)
	mg1:Merge(Duel.GetFusionMaterial(tp):Filter(Card.IsHasEffect,nil,EFFECT_EXTRA_FUSION_MATERIAL))
	local res=Duel.IsExistingMatchingCard(cm.Whitkinsffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	for _,v in pairs(le) do v:Reset() end
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.Whitkinsffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	return res
end
function cm.Whitkinsfstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local g=Duel.GetMatchingGroup(cm.Whitkinsfilter,tp,LOCATION_GRAVE,0,c,e)
	if g:GetCount()==0 then return false end
	local ag=g:GetMinGroup(cm.WhitkinsGetSequenceMinus,seq)
	local tg=ag:Filter(cm.Whitkinsfilter2,nil,e,tp,seq)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and tg:IsContains(chkc) end
	if chk==0 then return #tg>0 and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=tg:Select(tp,1,1,nil)
	local mg=Duel.GetMatchingGroup(cm.Whitkinsmfilter,tp,LOCATION_GRAVE,0,nil,sg:GetFirst():GetSequence(),seq,nil)
	sg:AddCard(c)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,1,tp,LOCATION_GRAVE)
end
function cm.Whitkinsfsop(id,att)
	return  function(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg~=2 then return end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.Whitkinsmfilter,tp,LOCATION_GRAVE,0,nil,tg:GetFirst():GetSequence(),tg:GetNext():GetSequence(),e)
	local le=cm.Whitkinsmust(e,mg1)
	local mg3=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e):Filter(Card.IsHasEffect,nil,EFFECT_EXTRA_FUSION_MATERIAL)
	local sg1=Duel.GetMatchingGroup(cm.Whitkinsffilter,tp,LOCATION_EXTRA,0,nil,e,tp,Group.__add(mg1,mg3),nil,chkf)
	for _,v in pairs(le) do v:Reset() end
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.Whitkinsffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2~=nil then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc)
			or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=nil
			if #mg3>0 then
				local le2=cm.Whitkinsmust(e,mg1)
				mat1=Duel.SelectFusionMaterial(tp,tc,Group.__add(mg1,mg3),nil,chkf)
				for _,v in pairs(le2) do v:Reset() end
			else mat1=mg1 end
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then cm.Whitkinsimmune(tc,tp,id,att) Duel.SpecialSummonComplete() end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			if #mat2<2 then goto cancel end
			local fop=ce:GetOperation()
			local f=Duel.SpecialSummon
			Duel.SpecialSummon=function(tgs,sumtyp,sump,...)
				local tgsg=Group.__add(tgs,tgs)
				if #tgsg==1 then
					if Duel.SpecialSummonStep(tgsg:GetFirst(),sumtyp,sump,...) then
						cm.Whitkinsimmune(tgsg:GetFirst(),sump) Duel.SpecialSummonComplete()
						return 1
					else return 0 end
				else return f(tgs,sumtyp,sump,...) end
			end
			fop(ce,e,tp,tc,mat2)
			Duel.SpecialSummon=f
		end
		tc:CompleteProcedure()
	end
	end
end
function cm.Whitkinsmust(e,g)
	local le={}
	for mtc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCode(EFFECT_MUST_BE_FMATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(1,0)
		mtc:RegisterEffect(e1,true)
		table.insert(le,e1)
	end
	return le
end
function cm.Whitkinsimmune(c,tp,id,att)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetAbsoluteRange(tp,LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e1:SetValue(cm.Whitkinsefilter(att))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end
function cm.Whitkinsefilter(att)
	return  function(e,te,c)
		return te:GetOwnerPlayer()~=c:GetControler() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(att)
	end
end
