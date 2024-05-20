--闪耀的萤火 天尘
function c28384498.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x289),3,3)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c28384498.condition)
	e1:SetTarget(c28384498.target)
	e1:SetOperation(c28384498.operation)
	c:RegisterEffect(e1)
	--noctchill
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c28384498.nccon)
	e2:SetOperation(c28384498.ncop)
	c:RegisterEffect(e2)
end
function c28384498.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c28384498.filter(c)
	return c:IsSetCard(0x283) and c:IsAbleToDeck() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c28384498.thfilter,c:GetControler(),LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetAttribute())
end
function c28384498.thfilter(c,lv,attr)
	return c:IsLevel(lv) and not c:IsAttribute(attr) and c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28384498.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(c28384498.filter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28384498,0)},
		{b2,aux.Stringid(28384498,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,b1,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=Duel.SelectTarget(tp,c28384498.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end
end
function c28384498.setfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c28384498.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(dg)
		if Duel.Destroy(dg,REASON_EFFECT)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28384498,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
			if rg:GetCount()>0 then
				Duel.HintSelection(rg)
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local attr=tc:GetAttribute()
			local lv=tc:GetLevel()
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c28384498.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv,attr)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c28384498.nccon(e,tp,eg,ep,ev,re,r,rp)
	if ev<2 then return end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x283) and p==tp and rp==1-tp
end
function c28384498.ncop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c28384498.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c28384498.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return e:GetHandler():GetControler()==tp and te:GetHandler():IsSetCard(0x283)
end
