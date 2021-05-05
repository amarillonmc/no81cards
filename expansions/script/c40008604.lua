--究极异兽-针刺之四颚针龙
function c40008604.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,c40008604.ovfilter,aux.Stringid(40008604,0),2,c40008604.xyzop)
	c:EnableReviveLimit() 
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008604,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c40008604.dacost)
	e3:SetOperation(c40008604.daop)
	c:RegisterEffect(e3) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c40008604.aclimit)
	e2:SetCondition(c40008604.actcon)
	c:RegisterEffect(e2)  
end
function c40008604.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(1) and c:GetOverlayCount()>1
end
function c40008604.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008604)==0 end
	Duel.RegisterFlagEffect(tp,40008604,RESET_PHASE+PHASE_END,0,1)
end
function c40008604.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008604.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c40008604.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c40008604.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end