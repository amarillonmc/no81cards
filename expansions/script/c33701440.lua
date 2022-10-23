--踏破新世界 ～开路之卷～
local m=33701440
local cm=_G["c"..m]
cm.named_with_NewVenture=1
function cm.NewVenture(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NewVenture
end
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_SINGLE)
	e03:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e03:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e03:SetRange(LOCATION_SZONE)
	e03:SetValue(1)
	c:RegisterEffect(e03)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.lpcon)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)
	local e8=e2:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8) 
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Effect 4
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SELF_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.tgccon)
	c:RegisterEffect(e2)
end
--Effect 1
--Effect 2
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return  eg:IsExists(cm.cfilter,1,nil,1-tp) and #g>0
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,m) 
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e8)
		tc=g:GetNext()
	end
end
--Effect 3 
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=p and Duel.GetFlagEffect(p,m+m)==0
end
function cm.filter(c)
	if  c:IsForbidden() or c:IsCode(m) then return false end
	return c:IsType(TYPE_CONTINUOUS) and cm.NewVenture(c)
		and c:CheckUniqueOnField(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() 
		and c:GetFlagEffect(m)==0 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+m)>0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_DECK) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			Duel.RegisterFlagEffect(tp,m+m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end 
--Effect 4
function cm.tgccon(e)
	return Duel.GetCurrentPhase()==PHASE_END 
end