--心象风景 我“我”
function c19209561.initial_effect(c)
	aux.AddCodeList(c,19209511,19209536,19209542)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,19209561)
	e1:SetTarget(c19209561.target)
	e1:SetOperation(c19209561.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,19209562)
	e2:SetTarget(c19209561.thtg)
	e2:SetOperation(c19209561.thop)
	c:RegisterEffect(e2)
end
function c19209561.thfilter(c,chk)
	return c:IsCode(19209536) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19209561.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c19209561.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c19209561.cfilter(chkc,19209536) end
	local b1=Duel.IsExistingMatchingCard(c19209561.thfilter,tp,LOCATION_DECK,0,1,nil,0)
	local b2=Duel.IsExistingTarget(c19209561.cfilter,tp,LOCATION_ONFIELD,0,1,nil,19209536) and Duel.IsPlayerCanDraw(tp,1)
	local b3=Duel.IsExistingMatchingCard(c19209561.cfilter,tp,LOCATION_ONFIELD,0,1,nil,19209542)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209561,0)},
		{b2,aux.Stringid(19209561,1)},
		{b3,aux.Stringid(19209561,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectTarget(tp,c19209561.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,19209536):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==3 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c19209561.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c19209561.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if not tc then return end
		--Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,aux.ExceptThisCard(e))
		if #g~=0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c19209561.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c19209561.cfilter(chkc,19209511) end
	if chk==0 then return Duel.IsExistingTarget(c19209561.cfilter,tp,LOCATION_ONFIELD,0,1,nil,19209511) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,0,0,tp,LOCATION_HAND)
end
function c19209561.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
