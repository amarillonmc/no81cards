--创界神 哈迪斯

local s, id = GetID()
s.named_with_Grandwalker=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)   
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil)
		and Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, 1, 0, 0)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	if Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD) > 0 then

		local tc = Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(tc, REASON_EFFECT)
		end
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


	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end