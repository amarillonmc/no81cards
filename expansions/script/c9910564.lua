--甜心机仆 天镜的礼物
function c9910564.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910550+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910564.spcon)
	e1:SetOperation(c9910564.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910564)
	e2:SetCost(c9910564.thcost)
	e2:SetTarget(c9910564.thtg)
	e2:SetOperation(c9910564.thop)
	c:RegisterEffect(e2)
end
function c9910564.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c9910564.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910564,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c9910564.costfilter(c)
	return c:IsSetCard(0x3951) and c:IsDiscardable()
end
function c9910564.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c9910564.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c9910564.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910564.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c9910564.thfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToHand()
end
function c9910564.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,1,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910564.thfilter,tp,LOCATION_DECK,0,nil)
	if ct~=0 and g1:GetCount()>0 and g2:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910564,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
		Duel.ShuffleHand(tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910564.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910564.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
