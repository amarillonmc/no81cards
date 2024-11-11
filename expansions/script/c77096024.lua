--夜间飞驰的铁处女
local m=77096024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.tfilter(c,e,tp,tc)
	local ck1=c:IsAttribute(ATTRIBUTE_DARK)
	local ck2=c:IsRace(RACE_FIEND)
	local ck3=c:IsAttack(2999) and c:IsDefense(2999)
	local ck4=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local ck5=Duel.GetMZoneCount(tp,tc)>0
	return ck1 and ck2 and ck3 and ck4 and ck5
end
function cm.filter(c,e,tp)
	local ck1=c:IsCode(77096021)
	local ck2=c:IsAbleToExtra()
	local ck3=Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)   
	return c:IsFaceup() and ck1 and ck2 and ck3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_EXTRA) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
  

