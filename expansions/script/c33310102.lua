--睡美人的小憇
local m=33310102
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.act)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and _G["c"..c:GetCode()].rssetcode and _G["c"..c:GetCode()].rssetcode=="Cochrot" and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c,e,tp)
end
function cm.matfilter(c,tc,e,tp)
	if c:GetRitualLevel(tc)<tc:GetLevel() then return false end
	if Duel.GetMZoneCount(tp,c,tp)<=0 then return false end
	if tc.mat_filter and not tc.mat_filter(c,tp) then return false end
	if c:IsLocation(LOCATION_GRAVE) then return
		c:IsAbleToRemove() and c:IsType(TYPE_RITUAL)
	else
		return c:IsReleasableByEffect(e)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cm.act(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local matc=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,tc,e,tp):GetFirst()
	tc:SetMaterial(Group.FromCards(matc))
	if matc:IsLocation(LOCATION_GRAVE) then
		if Duel.Remove(matc,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==0 then return end
	else
		if Duel.Release(matc,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==0 then return end
	end
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and _G["c"..c:GetCode()].rssetcode and _G["c"..c:GetCode()].rssetcode=="Cochrot" and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end