--幽域诞地 囚灵地牢
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.indtg)
	e3:SetValue(s.indct)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.rmcon)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
end
function s.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSetCard(0xa569)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function s.indtg(e,c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=e:GetHandler():GetControler()
end
function s.rmfilter(c)
	return c:IsFaceupEx() and c:IsCode(33300658) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE)
end
function s.spfilter(c,e,tp)
	return c:IsCode(33300659) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	if sg:GetCount()>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,1-tp)
		and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,1-tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end