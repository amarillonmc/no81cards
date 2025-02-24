--人理之基 静谧的哈桑
function c22021950.initial_effect(c)
	aux.AddCodeList(c,22021960)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021950,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c22021950.target)
	e1:SetOperation(c22021950.operation)
	c:RegisterEffect(e1)
	--to deck hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021950,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c22021950.condition)
	e2:SetTarget(c22021950.target)
	e2:SetOperation(c22021950.operation)
	c:RegisterEffect(e2)
	--to deck ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021950,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22021950.erecon)
	e3:SetCost(c22021950.erecost)
	e3:SetTarget(c22021950.target)
	e3:SetOperation(c22021950.operation)
	c:RegisterEffect(e3)
end
function c22021950.cfilter(c)
	return c:IsFaceup() and c:IsCode(22021960)
end
function c22021950.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021950.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22021950.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c22021950.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	Duel.SendtoDeck(c,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(1-tp)
	c:ReverseInDeck()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021950,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DRAW)
	e1:SetTarget(c22021950.sptg)
	e1:SetOperation(c22021950.spop)
	e1:SetReset(RESET_EVENT+0x1de0000)
	c:RegisterEffect(e1)
end
function c22021950.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22021950.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)>0 then
				Duel.SetLP(1-tp,math.ceil(Duel.GetLP(tp)/2))
		end
	end
end
function c22021950.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021950.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end