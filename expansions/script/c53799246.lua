local m=53799246
local cm=_G["c"..m]
cm.name="去常态"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsType(TYPE_TUNER) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,lv,e,tp)
end
function cm.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.gselect(g,slv)
	return g:GetSum(Card.GetLevel)<=slv
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local oc=Duel.GetOperatedGroup():GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not oc or not oc:IsLocation(LOCATION_REMOVED) or oc:IsFacedown() or ft<=0 then return end
	Duel.BreakEffect()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local slv=oc:GetLevel()
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,cm.gselect,false,1,math.min(2,ft),slv)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end
