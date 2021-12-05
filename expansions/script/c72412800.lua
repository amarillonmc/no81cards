--地狱的女神
function c72412800.initial_effect(c)
		--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412800,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c72412800.con)
	e1:SetTarget(c72412800.tg)
	e1:SetOperation(c72412800.op)
	c:RegisterEffect(e1)
end
function c72412800.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c72412800.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72412800.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72412800.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) 
	if chk==0 then return b1 or b2 or b3 end
end
function c72412800.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(72412800,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(72412800,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g2:GetCount()>0 then
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
	end
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72412800.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(72412800,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412800.spfilter),tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if g3:GetCount()>0 then
			Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end