--N#34 Speedster Sonic
function c31034013.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroProcedure(c, nil, aux.NonTuner(nil), 1)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c31034013.batfilter)
	c:RegisterEffect(e1)
	--cannot be target + cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c31034013.tgcon)
	e2:SetOperation(c31034013.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c31034013.check)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

function c31034013.batfilter(e,c)
	return not c:IsSetCard(0x891)
end

function c31034013.check(e,c)
	local obj=e:GetLabelObject()
	if c:GetMaterial():IsExists(Card.IsCode, 1, nil, 31034001) then obj:SetLabel(1) 
	else obj:SetLabel(0) end
end

function c31034013.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel() == 1
end

function c31034013.tgfilter(e,re,rp)
	return rp ~= e:GetHandlerPlayer()
end

function c31034013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31034013, 0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c31034013.tgfilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c31034013.actcon)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end

function c31034013.actcon(e)
	return Duel.GetAttacker() == e:GetHandler()
end