--食星鸟的婪音
function c20000258.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20000258+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c20000258.tg1)
	e1:SetOperation(c20000258.op1)
	c:RegisterEffect(e1)  
end
function c20000258.tgf1(c)
	return c:IsSetCard(0x3fd2)
end
function c20000258.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) 
		and Duel.IsExistingMatchingCard(c20000258.tgf1,tp,LOCATION_DECK,0,2,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c20000258.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g1=Duel.GetDecktopGroup(tp,1)
	local ct=g1:FilterCount(Card.IsSetCard,nil,0x3fd2)
	if ct~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000258,2))
		local g=Duel.SelectMatchingCard(tp,c20000258.tgf1,tp,LOCATION_DECK,0,1,1,nil) 
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end