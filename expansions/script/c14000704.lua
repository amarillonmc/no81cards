--无形重压 君主枯竭
local m=14000704
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.sumsuc)
	c:RegisterEffect(e2)
end
function cm.con(e,c)
	return not e:GetHandler():IsPublic()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if not c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,e:GetHandler())
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0,0xff)
	e1:SetCondition(cm.aclcon)
	e1:SetTarget(cm.disable)
	e1:SetCode(EFFECT_DISABLE)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetTargetRange(0xff,0)
	e2:SetCondition(cm.aclcon1)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetTarget(cm.disable)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetTargetRange(0xff,0)
	e4:SetCondition(cm.aclcon1)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetCondition(cm.discon)
	e5:SetOperation(cm.disop)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCondition(cm.discon1)
	Duel.RegisterEffect(e6,tp)
end
function cm.aclcon(e,c)
	local p=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(p,m)==0 and not Duel.IsPlayerAffectedByEffect(1-p,14000705)
end
function cm.aclcon1(e,c)
	local p=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(p,m)==0 and Duel.IsPlayerAffectedByEffect(1-p,14000705)
end
function cm.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) or not c:IsType(TYPE_MONSTER) and not (c:IsFacedown() and c:IsLocation(LOCATION_EXTRA))
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return re:GetHandler():IsControler(1-tp) and Duel.GetFlagEffect(tp,m)==0 and not Duel.IsPlayerAffectedByEffect(1-tp,14000705)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return re:GetHandler():IsControler(1-tp) and Duel.GetFlagEffect(tp,m)==0 and Duel.IsPlayerAffectedByEffect(1-tp,14000705)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,0,0,0)
end