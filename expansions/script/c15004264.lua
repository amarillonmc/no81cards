local m=15004264
local cm=_G["c"..m]
cm.name="奇影依·米德拉什"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5f31),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),true)
	--cannot spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--effect count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.scount)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetOperation(cm.ocount)
	c:RegisterEffect(e4)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.econ1)
	e3:SetValue(cm.elimit)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCondition(cm.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--send replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_SEND_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(cm.rtg)
	e7:SetValue(cm.rval)
	c:RegisterEffect(e7)
end
cm.name_beyond_Non_Vemoisit={94977269}
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function cm.scount(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(15004264,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.econ1(e)
	return e:GetHandler():GetFlagEffect(15004264)~=0
end
function cm.ocount(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(15004265,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.econ2(e)
	return e:GetHandler():GetFlagEffect(15004265)~=0
end
function cm.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and re and re:GetHandler()~=e:GetHandler() and c:IsAbleToHand() and eg:IsContains(c) and re:GetHandler():IsSetCard(0x5f31) end
	if aux.TRUE then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(15004263,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.thcon)
		e2:SetOperation(cm.thop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.thfilter(c)
	return c:GetFlagEffect(15004263)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end