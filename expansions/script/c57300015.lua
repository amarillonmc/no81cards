--流界初号机·武装强化
local m=57300015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFlagEffect(tp,0x3520)~=0 then
		Duel.ResetFlagEffect(tp,0x3520) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(cm.value)
		e1:SetTargetRange(LOCATION_MZONE,0)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e2,tp)
--cant remove,cant activate
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.flagcon)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetValue(cm.actlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--
		if Duel.GetFlagEffect(tp,0x3520)==0 then
		Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	end
function cm.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*100
	end
	--flag,limit
function cm.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,0x3520)~=0
end
function cm.actlimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsLocation(LOCATION_REMOVED) and not c:IsSetCard(0x3520)
end
	--
--tg and op
	--if Duel.GetFlagEffect(tp,0x3520)~=0 then
	--Duel.ResetFlagEffect(tp,0x3520) end
	--if Duel.GetFlagEffect(tp,0x3520)==0 then
	--Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
--