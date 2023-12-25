--人偶塑灵·魂芯解放
function c74521513.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c74521513.filter,LOCATION_DECK,c74521513.filter,aux.FilterBoolFunction(Card.IsLocation,LOCATION_ONFIELD),true)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74521513,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,74521513)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c74521513.setcon)
	e2:SetTarget(c74521513.settg)
	e2:SetOperation(c74521513.setop)
	c:RegisterEffect(e2)
end
function c74521513.filter(c)
	return c:IsSetCard(0x745)
end
function c74521513.cfilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c74521513.setcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c74521513.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c74521513.setfilter(c)
	return c:IsSetCard(0x745) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function c74521513.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74521513.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c74521513.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c74521513.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
