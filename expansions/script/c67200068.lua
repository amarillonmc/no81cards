--创刻-苏芳杏里咲『团聚时光』
function c67200068.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,67200068+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200068.activate)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200068,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200068.drcon)
	e2:SetTarget(c67200068.drtg)
	e2:SetOperation(c67200068.drop)
	c:RegisterEffect(e2) 
end
function c67200068.filter(c)
	return c:IsSetCard(0x9673) and c:IsAbleToHand()
end
function c67200068.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c67200068.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200068,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200068.drfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x673)
end
function c67200068.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200068.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200068.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67200068.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
