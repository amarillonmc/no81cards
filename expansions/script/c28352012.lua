--盛开的六出花 二重结果论
function c28352012.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c28352012.matfilter,nil,nil,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,1)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(c28352012.recon)
	e1:SetTarget(c28352012.retg)
	e1:SetOperation(c28352012.reop)
	c:RegisterEffect(e1)
	c28352012.recover_effect=e1
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c28352012.tdcon)
	e2:SetTarget(c28352012.tdtg)
	e2:SetOperation(c28352012.tdop)
	c:RegisterEffect(e2)
end
function c28352012.matfilter(c,syncard)
	return c:IsTuner(syncard) or Duel.GetLP(c:GetControler())>8000
end
function c28352012.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c28352012.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2000)
end
function c28352012.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c28352012.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000,REASON_EFFECT,true)
	Duel.Recover(1-tp,2000,REASON_EFFECT,true)
	Duel.RDComplete()
	local g=Duel.GetMatchingGroup(c28352012.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	if Duel.GetLP(tp)>=10000 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(28352012,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function c28352012.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c28352012.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=10000
end
function c28352012.tdfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x287) and c:IsLevel(4) and c:IsAbleToDeck()) then return false end
	local te=c.recover_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c28352012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if ct then
		for i=1,ct do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandler()==e:GetHandler() then check=false end
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c28352012.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and check end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c28352012.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c28352012.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		local te=tc.recover_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
