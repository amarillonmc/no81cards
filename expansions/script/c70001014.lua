--灼炎的魔导姬
local m=70001014
local cm=_G["c"..m]
function cm.initial_effect(c)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_REMOVED))
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge1:SetCode(EVENT_DRAW)
		Duel.RegisterEffect(ge2,0)
	end
end
	function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
end
	function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0
end