--星之开拓者-弗朗西斯·德雷克
function c22021410.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021410,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,22021410)
	e1:SetCondition(c22021410.condition)
	e1:SetCost(c22021410.cost)
	e1:SetTarget(c22021410.target)
	e1:SetOperation(c22021410.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,22021412)
	e2:SetCondition(c22021410.condition2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCountLimit(1,22021413)
	e3:SetCondition(c22021410.condition3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCountLimit(1,22021414)
	e4:SetCondition(c22021410.condition4)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCountLimit(1,22021415)
	e5:SetCondition(c22021410.condition5)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCountLimit(1,22021416)
	e6:SetCondition(c22021410.condition6)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCountLimit(1,22021417)
	e7:SetCondition(c22021410.condition7)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetCountLimit(1,22021418)
	e8:SetCondition(c22021410.condition8)
	c:RegisterEffect(e8)
end
function c22021410.filter(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(1) and c:IsLinkAbove(1)
end
function c22021410.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter,1,nil,tp)
end
function c22021410.filter2(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(2) and c:IsLinkAbove(2)
end
function c22021410.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter2,1,nil,tp)
end
function c22021410.filter3(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(3) and c:IsLinkAbove(3)
end
function c22021410.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter3,1,nil,tp)
end
function c22021410.filter4(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(4) and c:IsLinkAbove(4)
end
function c22021410.condition4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter4,1,nil,tp)
end
function c22021410.filter5(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(5) and c:IsLinkAbove(5)
end
function c22021410.condition5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter5,1,nil,tp)
end
function c22021410.filter6(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(6) and c:IsLinkAbove(6)
end
function c22021410.condition6(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter6,1,nil,tp)
end
function c22021410.filter7(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(7) and c:IsLinkAbove(7)
end
function c22021410.condition7(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter7,1,nil,tp)
end
function c22021410.filter8(c,tp)
	return c:IsSetCard(0x4ff1) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsLinkBelow(8) and c:IsLinkAbove(8)
end
function c22021410.condition8(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021410.filter8,1,nil,tp)
end
function c22021410.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22021410)==0 end
	Duel.RegisterFlagEffect(tp,22021410,RESET_CHAIN,0,1)
end
function c22021410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22021410.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
