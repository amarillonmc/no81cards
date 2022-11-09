--枪塔的鸟精
function c67200708.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200708,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c67200708.spcon1)
	e4:SetOperation(c67200708.spop1)
	c:RegisterEffect(e4)
	
end
function c67200708.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67200708.psfilter(c)
	return c:IsSetCard(0x67f) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200708.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(c67200708.psfilter,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200708.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
