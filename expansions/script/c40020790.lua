--库库尔坎的妖蛇神殿
local s,id=GetID()
function s.DarkSnake(c)
	local m = _G["c"..c:GetCode()]
	if m and m.named_with_DarkSnake then return true end
	if c:GetCode() == 40020764 and c:IsLocation(LOCATION_PZONE) then return true end
	return false
end
s.named_with_DarkSnake=1
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.con3)
	e3:SetValue(s.actfilter)
	c:RegisterEffect(e3)
end
function s.rafilter(c)
	return c:IsCode(40020764) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local hasZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
	if hasZone
	   and Duel.IsExistingMatchingCard(s.rafilter, tp, LOCATION_DECK, 0, 1, nil)
	   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp, s.rafilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 then
			Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
		end
	end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.DarkSnake,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.DarkSnake,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end
function s.con3(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,40020764)
end
function s.actfilter(e,re,tp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
