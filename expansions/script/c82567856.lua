--方舟骑士·狼魂日冕 拉普兰德
function c82567856.initial_effect(c)
	c:EnableReviveLimit()
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--special summon rule
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,82567856+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c82567856.hspcon)
	e4:SetOperation(c82567856.hspop)
	c:RegisterEffect(e4)
	--no effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTarget(c82567856.potg)
	e5:SetOperation(c82567856.poop)
	c:RegisterEffect(e5)
	--ATK Gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c82567856.val)
	c:RegisterEffect(e6)
end
function c82567856.hspfilter(c)
	return c:GetCounter(0x5825)>=1
end
function c82567856.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return false end
	local g=Duel.GetReleaseGroup(tp)
	return g:IsExists(c82567856.hspfilter,1,nil,g,ft)
end
function c82567856.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c82567856.hspfilter,1,1,nil,g,ft)
	Duel.Release(g1,REASON_COST+REASON_MATERIAL)
end
function c82567856.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
end
function c82567856.poop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c82567856.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function c82567856.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) 
end
function c82567856.filter(c)
	return c:GetLevel()>=4 and c:IsFaceup()
end
function c82567856.val(e,c)
	return Duel.GetMatchingGroupCount(c82567856.filter,c:GetControler(),0,LOCATION_MZONE,nil)*500
end
function c82567856.thcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)==0
end
function c82567856.thop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
end
