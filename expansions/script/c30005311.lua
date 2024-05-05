--深红之海
local m=30005311
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.immtg)
	e1:SetValue(cm.immval)
	c:RegisterEffect(e1)
	--Effect 2  
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
	--Effect 3 
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(m,1))
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_PHASE+PHASE_END)
	e14:SetRange(LOCATION_SZONE)
	e14:SetCountLimit(1)
	e14:SetCondition(cm.gtcon)
	e14:SetOperation(cm.gtop)
	c:RegisterEffect(e14) 
	--Effect 4  
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_LEAVE_GRAVE)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_GRAVE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCondition(cm.zcon)
	e51:SetCost(aux.bfgcost)
	e51:SetTarget(cm.ztg)
	e51:SetOperation(cm.zop)
	c:RegisterEffect(e51)   
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge11:SetOperation(cm.spmop)
		Duel.RegisterEffect(ge11,0)
	end
end
function cm.spmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+200,RESET_PHASE+PHASE_END,0,2)
		tc=eg:GetNext()
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE)
			and tc:GetPreviousControler()~=tc:GetReasonPlayer() then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
end
--Effect 1
function cm.zf(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
end 
function cm.con(e)   
	local g=Duel.GetMatchingGroup(cm.zf,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return #g>=3 
end
function cm.immtg(e,c)
	return cm.zf(c)
end
function cm.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--Effect 2
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.zf,tp,LOCATION_ONFIELD,0,nil)
	if #g<3 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,#g*500,REASON_EFFECT)
end  
--Effect 3
function cm.gtcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m)
	return ct>0
end
function cm.gtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end  
--Effect 4
function cm.ff(c)
	return c:GetSequence()<5
end
function cm.zcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_SZONE,0,nil)
	return #g==0
end
function cm.fzf(c,tp)
	return not c:IsForbidden() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:CheckUniqueOnField(tp)
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler()
	if chkc then return chkc~=ec and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.fzf(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.fzf,tp,LOCATION_GRAVE,0,1,ec,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,cm.fzf,tp,LOCATION_GRAVE,0,1,1,ec,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.zop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e)  then return end
	if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) or not tc:IsLocation(LOCATION_SZONE) then return false end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
	e2:SetOperation(cm.winop)
	tc:RegisterEffect(e2,true)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_ADJUST)
	e12:SetRange(LOCATION_SZONE)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD) 
	e12:SetOperation(cm.wwinop)
	tc:RegisterEffect(e12,true)
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_SZONE,0,e:GetHandler())
	if g:FilterCount(Card.IsFaceup,nil)>0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.wwinop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+200)
	if ct>=3 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end