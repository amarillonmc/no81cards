--雾锁窗上的爪痕
local s,id=GetID()
function s.release(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(s.rlcon)
    e1:SetCost(s.rlcost)
	e1:SetTarget(s.rltg)
	e1:SetOperation(s.rlop)
	c:RegisterEffect(e1)
end
function s.rlcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.cfilter(c)
	return c:IsSetCard(0x6c12) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup()
end
function s.rlfilter1(c)
	if not c:IsReleasableByEffect() then return false end
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return (c:IsType(TYPE_MONSTER) or c:GetOriginalType()&TYPE_MONSTER~=0) and g:IsExists(s.cfilter,1,nil)
end
function s.rlfilter2(c)
	return c:IsReleasableByEffect()
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlfilter1,tp,LOCATION_ONFIELD,0,1,nil)
	 and Duel.IsExistingMatchingCard(s.rlfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,s.rlfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g+#g2==2 then
		g:Merge(g2)
		Duel.HintSelection(g)
		Duel.Release(g,REASON_EFFECT)
	end
end
function s.tohand(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCountLimit(1,id-1000)
	e1:SetHintTiming(0,TIMING_MAIN_END)
    e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.rlfilter(c)
	return (c:GetOriginalType()&TYPE_MONSTER~=0 or c:IsType(TYPE_TOKEN)) and c:IsReleasable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function s.initial_effect(c)
	s.release(c)
	s.tohand(c)
end
