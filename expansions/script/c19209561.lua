--心象风景 我“我”
function c19209561.initial_effect(c)
	aux.AddCodeList(c,19209511,19209536,19209542)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19209561)
	e1:SetTarget(c19209561.target)
	--e1:SetOperation(c19209561.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209562)
	e2:SetCondition(c19209561.thcon)
	e2:SetTarget(c19209561.thtg)
	e2:SetOperation(c19209561.thop)
	c:RegisterEffect(e2)
end
function c19209561.cfilter(c,tp)
	return c:IsFaceup() and ((c:IsCode(19209536) and c:IsType(TYPE_PENDULUM) and Duel.IsPlayerCanDraw(tp,1)) or (c:IsCode(19209542) and c:IsAbleToGrave() and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=2))
end
function c19209561.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19209561.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c19209561.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c19209561.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if tc:IsCode(19209536) then
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(c19209561.teop)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
		e:SetOperation(c19209561.tgop)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	end
end
function c19209561.teop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c19209561.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,2,2,nil)
		if #g==2 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c19209561.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209561.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209561.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19209561.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,0,0,tp,LOCATION_HAND)
end
function c19209561.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
