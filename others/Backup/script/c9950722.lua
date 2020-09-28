--欧布·荣光形态
function c9950722.initial_effect(c)
	aux.AddCodeList(c,9950282)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9bd1),3)
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950722.atkval)
	c:RegisterEffect(e1)
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950722.atkval2)
	c:RegisterEffect(e1)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950722,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9950722.discon)
	e2:SetCost(c9950722.discost)
	e2:SetTarget(c9950722.distg)
	e2:SetOperation(c9950722.disop)
	c:RegisterEffect(e2)
 --set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950722,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9950722)
	e1:SetTarget(c9950722.settg)
	e1:SetOperation(c9950722.setop)
	c:RegisterEffect(e1)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950722.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950722.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950722,0))
end
function c9950722.atkval(e,c)
	return c:GetLinkedGroupCount()*1500
end
function c9950722.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c9950722.atkfilter(c)
	return c:IsFaceup() and  (c:IsCode(9950282) or aux.IsCodeListed(c,9950282)) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>=0
end
function c9950722.atkval2(e,c)
	local lg=c:GetLinkedGroup():Filter(c9950722.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c9950722.cfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
		and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9950722.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9950722.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c9950722.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c9950722.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9950722.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950722,0))
end
function c9950722.setfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9950722.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950722.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9950722.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9950722.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end