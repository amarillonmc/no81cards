--文明自灭游戏
function c11591300.initial_effect(c)
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,11591300+EFFECT_COUNT_CODE_DUEL)
	--e1:SetCondition(c11591300.condition)
	e1:SetOperation(c11591300.operation)
	c:RegisterEffect(e1)
end
function c11591300.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_CARD,0,11591300)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(c11591300.lkcon)
	e1:SetOperation(c11591300.lkop)
	Duel.RegisterEffect(e1,tp)
end
function c11591300.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c11591300.lkop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CIVILISATION_EXTINCTION_GAME = 0x81
	Duel.Hint(HINT_CARD,0,11591300)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then
		Duel.Win(1-tp,WIN_REASON_CIVILISATION_EXTINCTION_GAME)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst()
		if sc then
			Duel.LinkSummon(tp,sc,nil)
		else
			Duel.Win(1-tp,WIN_REASON_CIVILISATION_EXTINCTION_GAME)
		end
	end
end
