local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,2,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsRank(2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	local rct=e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	e:SetLabel(rct)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetLabel(e:GetLabel())
	e1:SetOperation(s.sop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevel(2) and c:IsDefenseBelow(400) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,e:GetLabel(),nil,e,tp,tc)
	s.cannottrigger(e,tc)
	for sc in aux.Next(sg) do if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then s.cannottrigger(e,sc) end end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	local g=Group.__add(tc,og)
	for ec in aux.Next(g) do
		for i=1,#og do ec:CopyEffect(ec:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD) end
	end
end
function s.cannottrigger(e,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
