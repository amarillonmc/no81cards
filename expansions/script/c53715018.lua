local m=53715018
local cm=_G["c"..m]
cm.name="欢乐树友 DB"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:GetCount()>0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) end
end
function cm.desfilter(c,seq)
	return c:GetSequence()<5 and math.abs(seq-c:GetSequence())==1
end
function cm.psfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsSetCard(0x353a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		local g=Group.__add(Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,0,nil,c:GetSequence()),c)
		local n=Duel.Destroy(g,REASON_EFFECT)
		local ct=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
		if n>1 and ct>0 and Duel.IsExistingMatchingCard(cm.psfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,cm.psfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,math.min(ct,n-1),nil)
			for tc in aux.Next(g) do Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
		end
	end
	SNNM.HTFPlacePZone(c,2,LOCATION_GRAVE,0,EVENT_FREE_CHAIN,m,tp)
end
