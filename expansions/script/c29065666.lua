--心之祅饰壤
function c29065666.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87aa))
	e2:SetValue(300)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to ex and p set 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c29065666.estg)
	e4:SetOperation(c29065666.esop)
	c:RegisterEffect(e4)
	--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,29065666)
	e5:SetCondition(c29065666.rmcon)
	e5:SetTarget(c29065666.rmtg)
	e5:SetOperation(c29065666.rmop)
	c:RegisterEffect(e5)
end
function c29065666.toexfil(c)
	return c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x87aa) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c29065666.psetfil(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x87aa) and not c:IsForbidden()
end
function c29065666.estg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065666.toexfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c29065666.psetfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_HAND)
end
function c29065666.esop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c29065666.toexfil,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c29065666.psetfil,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29065666,0))
	local sg1=g1:Select(tp,1,1,nil)
	Duel.SendtoExtraP(sg1,tp,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29065666,1))
	local tc=g2:Select(tp,1,1,nil):GetFirst() 
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c29065666.ckfil(c)
	return not c:IsReason(REASON_DRAW) and c:IsAbleToRemove() 
end
function c29065666.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c29065666.ckfil,1,nil) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x87aa)
end
function c29065666.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local xg=eg:Filter(c29065666.ckfil,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,xg,xg:GetCount(),tp,LOCATION_HAND)
end
function c29065666.rmop(e,tp,eg,ep,ev,re,r,rp)
	local xg=eg:Filter(c29065666.ckfil,nil)
	xg:KeepAlive()
	if Duel.Remove(xg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(xg)
		e1:SetCountLimit(1)
		e1:SetOperation(c29065666.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c29065666.retop(e,tp,eg,ep,ev,re,r,rp)
	local xg=e:GetLabelObject()
	Duel.SendtoHand(xg,1-tp,REASON_EFFECT)
end





