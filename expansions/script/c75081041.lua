--封魔造物 琳斯特拉
function c75081041.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081041,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75081041)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c75081041.tkcon)
	e1:SetCost(c75081041.thcost)
	e1:SetTarget(c75081041.tgtg)
	e1:SetOperation(c75081041.tgop)
	c:RegisterEffect(e1) 
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4) 
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c75081041.target)
	e3:SetOperation(c75081041.activate)
	c:RegisterEffect(e3) 
end
--
function c75081041.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c75081041.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081041.cfilter,1,nil)
end
function c75081041.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c75081041.tgfilter(c)
	return c:IsCode(75081038) and c:IsAbleToGrave()
end
function c75081041.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081041.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75081041.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c75081041.tgfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
--
function c75081041.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x754,1)
end
function c75081041.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c75081041.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75081041.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c75081041.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x754)
end
function c75081041.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x754,1)
	end
end