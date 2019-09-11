--蓬莱山辉夜·永夜返
function c9950041.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba1,0xba2),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c9950041.atcost)
	c:RegisterEffect(e1)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9950041.effcon)
	e1:SetLabel(1)
	e1:SetValue(c9950041.atkval)
	c:RegisterEffect(e1)
	--atkchange
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9950041.effcon)
	e2:SetLabel(2)
	e2:SetValue(0)
	e2:SetTarget(c9950041.atfilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e3)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	e2:SetCondition(c9950041.effcon)
	e2:SetLabel(3)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c9950041.effcon)
	e3:SetLabel(3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950041,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetLabel(4)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950041.discon)
	e3:SetTarget(c9950041.distg)
	e3:SetOperation(c9950041.disop)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950041,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950041.effcon)
	e1:SetLabel(5)
	e1:SetTarget(c9950041.rmtg)
	e1:SetOperation(c9950041.rmop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950041.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950041.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950041,2))
end
function c9950041.atcost(e,c,tp)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,1,REASON_COST)
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950041.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c9950041.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),1,1)*300
end
function c9950041.atfilter(e,c)
	return c:IsFaceup()
end
function c9950041.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c9950041.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9950041.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950041,2))
	end
end
function c9950041.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c9950041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950041.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9950041.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9950041.chlimit)
end
function c9950041.chlimit(e,ep,tp)
	return tp==ep
end
function c9950041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950041.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950041,2))
end