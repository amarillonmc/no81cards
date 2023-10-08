--胧之渺翳的玄机
function c9911326.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reveal hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCondition(c9911326.rvcon)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911326)
	e3:SetCost(c9911326.tdcost)
	e3:SetTarget(c9911326.tdtg)
	e3:SetOperation(c9911326.tdop)
	c:RegisterEffect(e3)
	--add to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9911327)
	e4:SetCondition(c9911326.matcon)
	e4:SetTarget(c9911326.mattg)
	e4:SetOperation(c9911326.matop)
	c:RegisterEffect(e4)
end
function c9911326.rvfilter(c)
	return c:IsFaceup() and c:GetOriginalRace()&RACE_FIEND>0 and c:GetOriginalType()&TYPE_MONSTER>0
end
function c9911326.rvcon(e)
	return Duel.IsExistingMatchingCard(c9911326.rvfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9911326.cfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function c9911326.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9911326.cfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9911326.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Release(g,REASON_COST)
end
function c9911326.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c9911326.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911326.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9911326.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9911326.gcheck(g)
	if #g==1 then return true end
	return aux.gfcheck(g,Card.IsLocation,LOCATION_MZONE,LOCATION_SZONE)
end
function c9911326.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911326.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c9911326.gcheck,false,1,2)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c9911326.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9911326.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9911326.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911326.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911326.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9911326.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9911326.matfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c9911326.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local tg=Group.CreateGroup()
		if c:IsRelateToEffect(e) then tg:AddCard(c) end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911326.matfilter2),tp,0,LOCATION_GRAVE,nil)
		if #g>0 then
			g=g:Select(tp,1,1,nil)
			tg:Merge(g)
		end
		if #tg>0 then
			Duel.HintSelection(tg)
			Duel.Overlay(tc,tg)
		end
	end
end
