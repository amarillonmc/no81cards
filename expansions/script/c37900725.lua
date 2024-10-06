--映入红瞳的世界
function c37900725.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c37900725.m,c37900725.xyz,3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37900725.con)
	e1:SetTarget(c37900725.tg)
	e1:SetValue(c37900725.val)
	e1:SetOperation(c37900725.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c37900725.con2)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c37900725.con4)
	e4:SetValue(c37900725.elimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c37900725.op5)
	c:RegisterEffect(e5)
end
function c37900725.m(c,xyzc)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ)
end
function c37900725.xyz(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c37900725.con(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return #og>0 and og:IsExists(Card.IsCode,1,nil,37900725-3)
end
function c37900725.q(c)
	return c:IsFaceup() and c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsLocation(4)
end
function c37900725.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and eg:IsExists(c37900725.q,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c37900725.val(e,c)
	return c37900725.q(c)
end
function c37900725.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,2000)
end
function c37900725.con2(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return #og>0 and og:IsExists(Card.IsCode,1,nil,37900725-2)
end
function c37900725.op5(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(37900725+ep,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c37900725.con4(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return #og>0 and og:IsExists(Card.IsCode,1,nil,37900725-1)
end
function c37900725.c(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c37900725.elimit(e,re,tp)
	return e:GetHandler():GetFlagEffect(37900725+tp)>3
end