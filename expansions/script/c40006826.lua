--睿智之蓝 LV3
function c40006826.initial_effect(c)
	--search S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40006826,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40006826)
	e1:SetCost(c40006826.cost)
	e1:SetTarget(c40006826.sptg)
	e1:SetOperation(c40006826.spop)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,40006826)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c40006826.target)
	e2:SetOperation(c40006826.operation)
	c:RegisterEffect(e2)
end
c40006826.lvupcount=1
c40006826.lvup={40006762}
function c40006826.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c40006826.filter(c,e,tp)
	return c:IsCode(40006762) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40006826.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40006826.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40006826.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40006826.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40006826.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c40006826.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c40006826.filter2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40006826.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40006826.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(c40006826.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c40006826.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40006826.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)==2 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c40006826.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
