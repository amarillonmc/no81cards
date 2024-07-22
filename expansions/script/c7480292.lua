--妖仙兽的罡风
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0xb3) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		if Duel.ChangePosition(c,POS_FACEDOWN)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetCondition(s.actcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if not e:GetLabel() or e:GetLabel()<=0 then return false end
	--
	local ct=6+e:GetLabel()
	local num=math.min(ct-3,15)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetDescription(aux.Stringid(id,num))
	e2:SetTargetRange(1,0)
	e2:SetValue(ct)
	e2:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e2,tp)
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb3) and c:IsAbleToHandAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(#g)
end
function s.actfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xb3) and c:IsFaceup()
end
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and not Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
