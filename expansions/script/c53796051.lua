local m=53796051
local cm=_G["c"..m]
cm.name="终末联组"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:CheckSubGroup(aux.dncheck,4,4) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
