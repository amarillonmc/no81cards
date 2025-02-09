--天之音 阐释
local m=14000783
local cm=_G["c"..m]
cm.named_with_Arcalling=1
function cm.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetCode(EVENT_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.drcon)
	e5:SetTarget(cm.drtg)
	e5:SetOperation(cm.drop)
	c:RegisterEffect(e5)
	--act in hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
end
function cm.ARC(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Arcalling
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp==1-tp
end
function cm.disfilter(c)
	return (cm.ARC(c) or (c:IsType(TYPE_COUNTER) and c:IsType(TYPE_TRAP))) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local b1=not c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
		local b2=Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local b3=Duel.GetFlagEffect(tp,m)==0 or c:IsLocation(LOCATION_GRAVE)
		return b1 or (b2 and b3)
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local tc=eg:GetFirst()
	while tc do
		tc:CancelToGrave()
		tc=eg:GetNext()
	end
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
		and cm.ARC(re:GetHandler())
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end