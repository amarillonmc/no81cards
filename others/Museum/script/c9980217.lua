--候补女神·拉姆
function c9980217.initial_effect(c)
	 --hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9980217.matcon)
	e1:SetValue(c9980217.matval)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980217,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9980217)
	e1:SetCost(c9980217.cost)
	e1:SetTarget(c9980217.target)
	e1:SetOperation(c9980217.operation)
	c:RegisterEffect(e1)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9980217.val)
	c:RegisterEffect(e2)
end
function c9980217.matcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),9980217)==0
end
function c9980217.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function c9980217.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(9980217)
end
function c9980217.matval(e,c,mg)
	return c:IsSetCard(0xbc8) and mg:IsExists(c9980217.mfilter,1,nil) and not mg:IsExists(c9980217.exmfilter,1,nil)
end
function c9980217.val(e,c)
	return Duel.GetMatchingGroupCount(tp,LOCATION_SZONE,LOCATION_SZONE)*-400
end
function c9980217.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9980217.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and c:IsRace(RACE_CYBERSE)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980217.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980217.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980217.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980217.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
