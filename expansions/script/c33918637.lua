--海皇女 罗德深渊后
function c33918637.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c33918637.matfilter,1,1)
	c:EnableReviveLimit()
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33918637,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33918637)
	e1:SetCondition(c33918637.sumcon)
	e1:SetCost(c33918637.sumcost)
	e1:SetTarget(c33918637.sumtg)
	e1:SetOperation(c33918637.sumop)
	c:RegisterEffect(e1)
end
function c33918637.matfilter(c)
	return (c:IsLinkSetCard(0x77) or c:IsLinkSetCard(0x75)) and not c:IsLinkCode(33918637)
end
function c33918637.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33918637.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c33918637.filter(c)
	return (c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_FISH) or c:IsRace(RACE_AQUA)) and c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end
function c33918637.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33918637.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c33918637.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c33918637.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end