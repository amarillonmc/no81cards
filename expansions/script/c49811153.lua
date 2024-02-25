--インヴェルズ·トリオ
function c49811153.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa),4,2,c49811153.ovfilter,aux.Stringid(49811153,0))
    c:EnableReviveLimit()
	--atk update
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c49811153.val)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811153,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49811153.drcon)
	e2:SetTarget(c49811153.drtg)
	e2:SetOperation(c49811153.drop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811153,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c49811153.discon)
	e3:SetCost(c49811153.discost)
	e3:SetTarget(c49811153.distg)
	e3:SetOperation(c49811153.disop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c49811153.econ)
	e4:SetValue(c49811153.efilter)
	c:RegisterEffect(e4)
end
function c49811153.ovfilter(c)
	local lv=c:GetLevel()
    return c:IsFaceup() and c:IsSetCard(0x100a) and lv>=8
end
function c49811153.val(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c49811153.drcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,84488827)
end
function c49811153.drfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x100a)
end
function c49811153.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c49811153.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct+1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct+1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
end
function c49811153.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c49811153.drfilter,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,ct+1,REASON_EFFECT)
end
function c49811153.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,62007535)
end
function c49811153.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c49811153.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c49811153.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c49811153.econ(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,94092230)
end
function c49811153.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end