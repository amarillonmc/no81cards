--荒碑守的继承
local m=14000394
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_GRAVE,0,1,c,mg,c)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ffilter(c,mg,fc)
	return fc:CheckFusionMaterial(mg,c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fc=Duel.GetFirstTarget()
	if not (fc:IsRelateToEffect(e) and fc:IsFaceup()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,fc,e,tp)
	if mg:IsExists(cm.ffilter,1,nil,mg,fc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=mg:FilterSelect(tp,cm.ffilter,1,1,nil,mg,fc)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.SendtoDeck(fc,nil,2,REASON_EFFECT)
			end
		end
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end