local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+500)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.filter(c,ec)
	return c:IsSetCard(0x30) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp,ec)
	return c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,c):GetFirst()
	if tc and Duel.Equip(tp,tc,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.desfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x30) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.desfilter,1,nil) and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=eg:Filter(s.desfilter,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	end
end
