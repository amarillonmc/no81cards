--├军团┤
function c60151199.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151199+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60151199.cointg)
	e1:SetOperation(c60151199.coinop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c60151199.ctcon)
	e2:SetOperation(c60151199.ctop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(60151199)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9b23))
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(60151199,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c60151199.cost3)
	e5:SetOperation(c60151199.op3)
	c:RegisterEffect(e5)
end
function c60151199.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c60151199.filter2(c)
	return c:IsAbleToGrave()
end
function c60151199.coinop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local res=0
	res=Duel.TossCoin(tp,1)
	if res==0 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c60151199.cfilter(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and (c:IsReason(REASON_EFFECT))
end
function c60151199.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c60151199.cfilter,1,nil) and re:GetHandler():IsSetCard(0x9b23)
end
function c60151199.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local ct=eg:FilterCount(c60151199.cfilter,nil)
	e:GetHandler():AddCounter(0x101b,ct)
end
function c60151199.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x101b,3,REASON_COST)
	and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x101b,3,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60151199.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(60151101,0)) then Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151199.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end