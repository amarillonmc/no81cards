--虚拟YouTuber 铃木雏
function c33700384.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttackAbove,2100),2,false)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c33700384.aclimit)
	e2:SetCondition(c33700384.actcon)
	c:RegisterEffect(e2)
	--tg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700384,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c33700384.condition)
	e1:SetOperation(c33700384.operation)
	c:RegisterEffect(e1)
end
function c33700384.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c33700384.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c33700384.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c33700384.actcon(e)
	return Duel.GetAttacker():IsControler(e:GetHandlerPlayer()) and not Duel.GetAttackTarget()
end