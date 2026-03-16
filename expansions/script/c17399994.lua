-- 正义
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.oppcon)
	e2:SetTarget(s.opptg)
	e2:SetOperation(s.oppop)
	c:RegisterEffect(e2)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,PLAYER_ALL,LOCATION_ALL)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	s.operation_logic(e,tp)
end
function s.operation_logic(e,tp)
	local c=e:GetHandler()
	local loc = LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA
	local g1 = Duel.GetFieldGroup(tp, loc, 0)
	local g2 = Duel.GetFieldGroup(tp, 0, loc)
	local fd = Duel.GetMatchingGroup(Card.IsFacedown, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	if #fd > 0 then
		Duel.ConfirmCards(tp, fd)
		Duel.ConfirmCards(1-tp, fd)
	end
	if #g1 > 0 then Duel.ConfirmCards(1-tp, g1) end
	if #g2 > 0 then Duel.ConfirmCards(tp, g2) end
	local all_cards = Duel.GetFieldGroup(tp, loc, loc)
	local sg = all_cards:Filter(function(tc) return tc:GetOwner() ~= tc:GetControler() end, nil)	
	if #sg > 0 then
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.aclimit)
	Duel.RegisterEffect(e2,tp)
end
function s.aclimit(e,re,tp)
	return re:IsHasCategory(CATEGORY_CONTROL)
end
function s.oppcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.opptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,PLAYER_ALL,LOCATION_ALL)
end
function s.oppop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp, aux.Stringid(id,2)) then
		s.operation_logic(e,1-tp)
	end
end