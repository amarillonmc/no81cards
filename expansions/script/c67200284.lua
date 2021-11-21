--封缄之都 古拉塞斯塔
function c67200284.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)  
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x674))
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)  
	--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_RELEASE_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200284.reptg)
	e3:SetValue(c67200284.repval)
	c:RegisterEffect(e3)
end
--
function c67200284.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x674)
end
function c67200284.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x674)
end
function c67200284.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c67200284.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c67200284.filter,tp,LOCATION_DECK,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(67200284,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200284,0))
		local g=Duel.SelectMatchingCard(tp,c67200284.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_CARD,0,67200284)
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		return true
	else return false end
end
function c67200284.repval(e,c)
	return c67200284.repfilter(c,e:GetHandlerPlayer())
end


