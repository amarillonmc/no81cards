--拨云见日的闪蝶幻乐
function c9911466.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911466.target)
	e1:SetOperation(c9911466.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9911466.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911466.thtg)
	e2:SetOperation(c9911466.thop)
	c:RegisterEffect(e2)
end
function c9911466.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x3952) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0) then return false end
	local te=c.morfonica_summon_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c9911466.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911466.efffilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9911466.efffilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	if tc:IsFaceup() then Duel.HintSelection(g)
	else Duel.ConfirmCards(1-tp,tc) end
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.morfonica_summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,9911466) end
end
function c9911466.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=tc.morfonica_summon_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.RegisterFlagEffect(tp,tc:GetOriginalCode()+10000,0,0,1)
end
function c9911466.thcon(e,tp,eg,ep,ev,re,r,rp)
	local cont,loc,attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_ATTRIBUTE)
	return cont==tp and (LOCATION_GRAVE+LOCATION_REMOVED)&loc~=0 and (ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)&attr~=0
end
function c9911466.thfilter(c,rc)
	return c:IsSetCard(0x3952) and c:IsType(TYPE_MONSTER) and not c:IsCode(rc:GetCode()) and c:IsAbleToHand()
end
function c9911466.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc and Duel.IsExistingMatchingCard(c9911466.thfilter,tp,LOCATION_DECK,0,1,nil,rc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911466.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911466.thfilter,tp,LOCATION_DECK,0,1,1,nil,rc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
