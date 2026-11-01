--向女王献花
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11772170)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.pfilter(c)
	return c:IsCode(11772170) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end 
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local b2=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>=6 and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local b2=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>=6 and Duel.IsPlayerCanDraw(tp,2)
	if not b1 and not b2 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
