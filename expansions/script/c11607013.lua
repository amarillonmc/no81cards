--紫之璀璨原钻
function c11607013.initial_effect(c)
	-- 展示炸卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11607013,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11607013)
	e1:SetCost(c11607013.cost)
	e1:SetTarget(c11607013.destg)
	e1:SetOperation(c11607013.desop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c11607013.quickcon)
	c:RegisterEffect(e3)
	-- 遗言检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11607013,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11607014)
	e2:SetTarget(c11607013.thtg)
	e2:SetOperation(c11607013.thop)
	c:RegisterEffect(e2)
end
-- 1
function c11607013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.ShuffleHand(tp)
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
end
function c11607013.fusionfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6225) and c:IsType(TYPE_FUSION)
end
function c11607013.quickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11607013.fusionfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c11607013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local handg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_HAND,0,nil,RACE_ROCK)
		local fieldg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		return handg:GetCount()>0 and fieldg:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end
function c11607013.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local handg=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND,0,1,1,nil,RACE_ROCK)
	if #handg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local fieldg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #fieldg==0 then return end
	local g=Group.FromCards(handg:GetFirst(),fieldg:GetFirst())
	Duel.Destroy(g,REASON_EFFECT)
end
-- 2
function c11607013.thfilter(c)
	return c:IsSetCard(0x6225) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c11607013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11607013.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11607013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11607013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11607013.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11607013.splimit(e,c)
	return not c:IsRace(RACE_ROCK) and c:IsLocation(LOCATION_EXTRA)
end
