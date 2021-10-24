--伪装兽 迫近恐惧
function c35300316.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c35300316.ffilter,2,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--hand remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35300316,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,35300316)
	e4:SetTarget(c35300316.rmtg2)
	e4:SetOperation(c35300316.rmop2)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(35300316,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,35300416)
	e5:SetCondition(c35300316.ovcon)
	e5:SetTarget(c35300316.negtg)
	e5:SetOperation(c35300316.negop)
	c:RegisterEffect(e5)
	--atk/def up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c35300316.atkup)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
--fusion material
function c35300316.ffilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAttack(0)
end
--atk/def up
function c35300316.atkfilter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c35300316.atkup(e,c)
	return Duel.GetMatchingGroupCount(c35300316.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*700
end
--fusion material
function c35300316.ffilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAttack(0)
end
--atk/def up
function c35300316.atkfilter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c35300316.atkup(e,c)
	return Duel.GetMatchingGroupCount(c35300316.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*700
end
--hand remove
function c35300316.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c35300316.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=g:RandomSelect(tp,1)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--negate
function c35300316.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local rtype=bit.band(re:GetActiveType(),0x7)
	return Duel.GetTurnPlayer()==tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c35300316.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,rtype)
end
function c35300316.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToDeck() and c:IsFaceup()
end
function c35300316.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c35300316.negop(e,tp,eg,ep,ev,re,r,rp)
	local rtype=bit.band(re:GetActiveType(),0x7)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c35300316.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,rtype)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
