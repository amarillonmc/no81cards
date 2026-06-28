--创界神 倭建命
local s, id = GetID()
s.named_with_Grandwalker=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.DrivenForce(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_DrivenForce
end
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD, 0)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_PZONE) 
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.drcon)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
end
function s.indtg(e, c)
	if c == e:GetHandler() then return true end
	return c:IsFaceup() and c:IsType(TYPE_SPELL + TYPE_TRAP) and (s.ForceFighter(c) or s.DrivenForce(c))
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	return (r & REASON_EFFECT) ~= 0
		and re and (s.ForceFighter(re:GetHandler()) or s.DrivenForce(re:GetHandler()))
		and rp == tp 
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)

	if Duel.IsPlayerCanDraw(tp, 1) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_CARD, 0, id)

		if Duel.Draw(tp, 1, REASON_EFFECT) > 0 then

			local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, LOCATION_GRAVE, LOCATION_GRAVE, nil)
			if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then

				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)

				local sg = g:Select(tp, 1, 1, nil)
				Duel.HintSelection(sg)

				Duel.SendtoDeck(sg, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
			end
		end
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if s.Grandwalker(rc) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetFlagEffect(tp,id)==0 then
			if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end

