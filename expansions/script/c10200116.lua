--幻叙·见习巫女-朔影
function c10200116.initial_effect(c)
	--Special Summon from hand/deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200116,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10200116)
	e1:SetTarget(c10200116.e1tg)
	e1:SetOperation(c10200116.e1op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Recover LP when banished from GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200116,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10200117)
	e3:SetCondition(c10200116.e3con)
	e3:SetTarget(c10200116.e3tg)
	e3:SetOperation(c10200116.e3op)
	c:RegisterEffect(e3)
end
--Effect 1: Target
function c10200116.e1filter(c,e,tp)
	return c:IsCode(10200102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200116.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10200116.e1filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
--Effect 1: Operation
function c10200116.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200116.e1filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Release(e:GetHandler(),REASON_EFFECT)
	end
end
--Effect 2: Condition - banished from GY
function c10200116.e3con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
--Effect 2: Filter
function c10200116.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x838)
end
--Effect 2: Target
function c10200116.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200116.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10200116.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
--Effect 2: Operation
function c10200116.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10200116.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end