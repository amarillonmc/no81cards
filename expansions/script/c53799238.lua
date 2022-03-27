local m=53799238
local cm=_G["c"..m]
cm.name="生前建构"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then return end
	local tc=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1):GetFirst()
	Duel.ConfirmCards(tp,tc)
	local res1=tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 and tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
	local res2=(tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE,1-tp)>0) and tc:IsSSetable()
	if (res1 or res2) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		if res1 then
			Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,tc)
		else Duel.SSet(1-tp,tc) end
	end
	Duel.ShuffleHand(1-tp)
end
