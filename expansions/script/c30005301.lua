--蔚蓝魔装 XXIV
local m=30005301
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(cm.sumcon)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(cm.sumlimit)
	c:RegisterEffect(e2)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCost(cm.tcost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,0))
	--e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetCode(EVENT_LEAVE_FIELD)
	--e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCondition(cm.tcon)
	--e3:SetCost(cm.tcost)
	--e3:SetTarget(cm.ttg)
	--e3:SetOperation(cm.top)
	--c:RegisterEffect(e3)
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCondition(cm.ztcon)
	e51:SetCost(cm.tcost)
	e51:SetTarget(cm.ttg)
	e51:SetOperation(cm.top)
	c:RegisterEffect(e51)   
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetCondition(cm.lecon)
		ge1:SetOperation(cm.leop)
		Duel.RegisterEffect(ge1,0)
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge11:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge11,0)
	end
end
--all
function cm.zpf(c,tp)
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0 and bit.band(c:GetPreviousTypeOnField(),TYPE_CONTINUOUS)~=0
	local b3=bit.band(c:GetPreviousRaceOnField(),RACE_FIEND)~=0
	local b4=c:GetReasonPlayer()==1-tp
	return b1 and (b2 or b3) and b4 
end
function cm.lecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.zpf,1,nil,0) or eg:IsExists(cm.zpf,1,nil,1)
end 
function cm.leop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.zpf,nil,0)
	local bg=eg:Filter(cm.zpf,nil,1)
	if #ag>0 then Duel.RegisterFlagEffect(0,m+m,RESET_PHASE+PHASE_END,0,1) end
	if #bg>0 then Duel.RegisterFlagEffect(1,m+m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetOriginalType()&TYPE_TRAP==0 then 
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,2)
		end
		tc=eg:GetNext()
	end
end
--all summon limit
function cm.sumcon(e)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m)
	return ct>3
end
function cm.sumlimit(e,se,sp,st,pos,tp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m)
	return ct>3
end
--Effect 1
function cm.rsf(c,tp)
	if not c:IsType(TYPE_TRAP) then return false end
	if not c:IsType(TYPE_CONTINUOUS) then return false end
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	local tge=nil
	if re then
		val=re:GetValue()
		tge=re:GetTarget()
	end
	if c:IsLocation(LOCATION_HAND) then
		return val==nil and (tae==nil or tae(re,c))
	else
		return c:IsReleasableByEffect()
	end
end
function cm.ff(c)
	local b1=c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
	local b2=c:IsCode(30005305,30005306,30005307)
	return (b1 or b2) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,tp)
	if chk==0 then return #g>0 and #tg>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	cm.ddop(e,tp)
	local tg=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil,tp)
	if #tg==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	if #rg==0 or Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local gt=tg:Select(tp,1,1,nil)
	if #gt==0 then return false end
	Duel.SendtoHand(gt,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,gt)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--Effect 2
function cm.thcf(c,tp)
	if c:GetPreviousLocation()~=LOCATION_ONFIELD then return false end
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_CONTINUOUS)~=0 and bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b3=bit.band(c:GetPreviousRaceOnField(),RACE_FIEND)~=0
	local b4=c:GetReasonPlayer()==1-tp
	return b1 and b2 and (b3 or b4)
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thcf,1,nil,tp)
end 
function cm.ztcon(e)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+m)
	return ct>0
end
function cm.zf(c)
	if c:IsForbidden() then return false end
	return c:IsAttack(2700) and c:IsDefense(1000) and c:IsRace(RACE_FIEND)
end
function cm.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.zf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetHandler():GetFieldID()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.zf),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return false end
			tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e11:SetCode(EVENT_PHASE+PHASE_END)
			e11:SetCountLimit(1)
			e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e11:SetLabel(fid)
			e11:SetLabelObject(tc)
			e11:SetCondition(cm.thcon)
			e11:SetOperation(cm.thop)
			Duel.RegisterEffect(e11,tp)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m+100)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end