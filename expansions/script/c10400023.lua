--UESTCer·光之秩序
local m=10400023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3680),aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10400023.discon)
	e4:SetCost(c10400023.discost)
	e4:SetTarget(c10400023.distg)
	e4:SetOperation(c10400023.disop)
	c:RegisterEffect(e4)
end
function c10400023.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10400023.cfilter(c)
	return c:IsSetCard(0x680) and c:IsType(TYPE_FIELD) and c:IsDiscardable()
end
function c10400023.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10400023.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10400023.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c10400023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10400023.ffilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c10400023.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local fg=Duel.GetMatchingGroup(c10400023.ffilter,tp,LOCATION_DECK,0,nil)
		if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10400023,0)) then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local sg=fg:Select(tp,1,1,nil)
		   Duel.SendtoHand(sg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg)
		end
	end
end
