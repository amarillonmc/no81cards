--战车道计策·偷袭
function c9910116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910116.target)
	e1:SetOperation(c9910116.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c9910116.thcost)
	e2:SetTarget(c9910116.thtg)
	e2:SetOperation(c9910116.thop)
	c:RegisterEffect(e2)
end
function c9910116.spfilter(c,e,tp)
	return c:IsSetCard(0x952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910116.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910116.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910116.zcdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x952)
end
function c9910116.gyfilter(c,g)
	return g:IsContains(c)
end
function c9910116.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910116.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910116.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		end
		Duel.BreakEffect()
		local tc=Duel.GetFirstTarget()
		if not (tc and tc:IsRelateToEffect(e)) then return end
		local tg=Duel.GetMatchingGroup(c9910116.zcdfilter,tp,LOCATION_MZONE,0,nil)
		local sc=tg:GetFirst()
		local sg=Group.CreateGroup()
		while sc do
			local sg1=Duel.GetMatchingGroup(c9910116.gyfilter,tp,0,LOCATION_MZONE,nil,sc:GetColumnGroup())
			sg:Merge(sg1)
			sc=tg:GetNext()
		end
		if sg:IsContains(tc) then Duel.Destroy(tc,REASON_EFFECT) end
	end
end
function c9910116.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x952) and c:IsReleasable()
		and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c9910116.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910116.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c9910116.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910116.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910116.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
