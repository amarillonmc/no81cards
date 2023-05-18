--炎王神 阿耆尼
function c98920576.initial_effect(c)
	 --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c98920576.splimit)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920576,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98920576.sptg)
	e1:SetOperation(c98920576.spop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920576,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,98920576)
	e2:SetCondition(c98920576.thcon)
	e2:SetTarget(c98920576.thtg)
	e2:SetOperation(c98920576.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c98920576.thcon1)
	e3:SetOperation(c98920576.thop1)
	c:RegisterEffect(e3)
end
function c98920576.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x81)
end
function c98920576.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceupEx()
end
function c98920576.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920576.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,0,c)
	if chk==0 then return g:CheckSubGroup(aux.mzctcheck,2,2,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #g1>0 and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
end
function c98920576.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c98920576.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,e:GetHandler())
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	if Duel.Destroy(g1,REASON_EFFECT)==0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98920576.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x81)
end
function c98920576.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_EFFECT) or (bit.band(r,REASON_EFFECT)~=0 and not re:GetHandler():IsSetCard(0x81))
end
function c98920576.thfilter(c)
	return c:IsSetCard(0x81) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c98920576.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920576.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920576.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920576.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920576.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920576.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.SelectYesNo(tp,aux.Stringid(98920576,0)) then 
		   local c=e:GetHandler()
		   if not c:IsRelateToEffect(e) then return end
		   if aux.NecroValleyNegateCheck(c) then return end
		   if not aux.NecroValleyFilter()(c) then return end
		   local b1=c:IsAbleToHand()
		   local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		   local op=0
		   if b1 and not b2 then
			  op=Duel.SelectOption(tp,1190)
		   end
		   if not b1 and b2 then
			  op=Duel.SelectOption(tp,1152)+1
		   end
		   if b1 and b2 then
			  op=Duel.SelectOption(tp,1190,1152)
		   end
		   if op==0 then
			  Duel.SendtoHand(c,nil,REASON_EFFECT)
		   end
		   if op==1 then
			  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		   end
	   end
	end
end