--Megurine Music Bang!
function c60151422.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,60151422+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c60151422.target)
	e1:SetOperation(c60151422.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
function c60151422.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3b28) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
end
function c60151422.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60151422.filter,tp,LOCATION_MZONE,0,1,nil,tp) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60151422.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60151422.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		end
	end
end
