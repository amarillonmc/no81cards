--术结天缘骑 煌磷结骑
function c67200402.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)  
	--destroy & setPendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200402,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200402)
	e1:SetCondition(c67200402.pccon)
	e1:SetTarget(c67200402.pctg)
	e1:SetOperation(c67200402.pcop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200402,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c67200402.sptg)
	e2:SetOperation(c67200402.spop)
	c:RegisterEffect(e2)
end
function c67200402.pccon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c67200402.pcfilter(c)
	return c:IsCode(67200401) and not c:IsForbidden() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c67200402.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c67200402.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_PZONE)
end
function c67200402.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200402.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	Duel.BreakEffect()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT) 
end
--
function c67200402.spfilter(c,e,tp)
	return c:IsCode(67200401) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200402.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(c67200402.spfilter,tp,LOCATION_DECKBOT,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECKBOT)
end
function c67200402.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if tc:GetCode()==67200401 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local gg2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
		gg:Merge(gg2)
		if gg:GetCount()>0 then
			Duel.SendtoHand(gg,nil,REASON_EFFECT)
		end
	end
end


