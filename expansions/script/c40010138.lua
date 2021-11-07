--惩处的击退者
local m=40010138
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.rfilter(c)
	return (cm.Revenger(c) or c:IsCode(40010072)) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_MZONE 
		return Duel.IsExistingMatchingCard(cm.rfilter,tp,loc,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,loc,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_MZONE 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,loc,0,nil)
	--if g:GetCount()>0 then
	   -- local sg=g:Select(tp,1,g,nil)
	local ct=Duel.Release(g,REASON_EFFECT)
	Duel.BreakEffect()
	local op=0
	local b1=Duel.IsPlayerCanDraw(tp,ct)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_HAND+LOCATION_GRAVE,ct,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif b2 then Duel.SelectOption(tp,aux.Stringid(m,1)) op=1
	else return end
	if op==0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>ct then ft=ct end
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local fg=sg:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ft))
			Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

