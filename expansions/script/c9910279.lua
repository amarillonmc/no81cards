--星幽使 二条院羽月
function c9910279.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910279)
	e1:SetCost(c9910279.cost)
	e1:SetTarget(c9910279.target)
	e1:SetOperation(c9910279.operation)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910279,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,9910280)
	e2:SetCost(c9910279.thcost)
	e2:SetTarget(c9910279.thtg)
	e2:SetOperation(c9910279.thop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911771)
	e3:SetCondition(c9910279.discon)
	e3:SetTarget(c9910279.distg)
	e3:SetOperation(c9910279.disop)
	c:RegisterEffect(e3)
end
function c9910279.cfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c9910279.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910279.cfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910279.cfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910279.spfilter(c,e,tp)
	return c:IsSetCard(0x3957) and c:IsType(TYPE_LINK) and c:IsLink(2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910279.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910279.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910279.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910279.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910279.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910279.thfilter(c,e,tp,mc)
	local res=not c:IsLocation(LOCATION_MZONE) and Duel.GetMZoneCount(tp,mc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return c:IsFaceupEx() and (c:GetOriginalType()&(TYPE_PENDULUM|TYPE_MONSTER)==TYPE_PENDULUM|TYPE_MONSTER)
		and (c:IsAbleToHand() or res)
end
function c9910279.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp)
		and c9910279.thfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c9910279.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c9910279.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	end
end
function c9910279.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		if tc:IsLocation(LOCATION_GRAVE) and aux.NecroValleyNegateCheck(tc) then return end
		local res=not tc:IsLocation(LOCATION_MZONE) and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if res and (not tc:IsAbleToHand() or Duel.SelectOption(tp,aux.Stringid(9910279,1),1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c9910279.lfilter(c,mc)
	return c:IsSetCard(0x3957) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(mc)
end
function c9910279.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(c9910279.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
function c9910279.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910279.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN)
		and Duel.SelectYesNo(tp,aux.Stringid(9910279,2)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp,POS_FACEDOWN)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleExtra(1-tp)
	end
end
