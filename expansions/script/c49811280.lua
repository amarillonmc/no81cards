--核成源气动语者
function c49811280.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--link summon
	c:SetUniqueOnField(1,0,49811280)
	aux.AddLinkProcedure(c,c49811280.mfilter,1)
	c:EnableReviveLimit()
	--Cannot Banish
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c49811280.rmlimit)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(c49811280.target)
	e2:SetOperation(c49811280.operation)
	c:RegisterEffect(e2)
end
function c49811280.mfilter(c)
	return c:IsLevelAbove(3) and c:IsLinkSetCard(0x1d)
end
function c49811280.rmlimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsCode(36623431)
		and r&REASON_EFFECT~=0 and re:GetOwnerPlayer()~=tp
end
function c49811280.lfilter(c)
	return c:IsPosition(POS_ATTACK) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c49811280.dfilter(c)
	return c:IsPosition(POS_DEFENSE) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c49811280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=Duel.SelectOption(tp,aux.Stringid(49811280,0),aux.Stringid(49811280,1))
	e:SetLabel(op)
end
function c49811280.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0,LOCATION_HAND)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0,LOCATION_GRAVE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetCondition(c49811280.gravecon)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c49811280.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end