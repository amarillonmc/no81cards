--机甲忍者 黑光
function c98920256.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c98920256.mfilter,1)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920256.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920256,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920256)
	e2:SetCost(c98920256.setcost)
	e2:SetTarget(c98920256.settg)
	e2:SetOperation(c98920256.setop)
	c:RegisterEffect(e2)
end
function c98920256.lkfilter(c)
	return c:IsFaceup() and c:IsFacedown()
end
function c98920256.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c98920256.lkfilter,1,nil)
end
function c98920256.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x2b)
end
function c98920256.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920256.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c98920256.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c98920256.filter(c,chk)
	return c:IsSetCard(0x61) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(chk)
end
function c98920256.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) and c:IsDiscardable()
end
function c98920256.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920256.filter,tp,LOCATION_DECK,0,1,nil,true) end
end
function c98920256.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98920256.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		local dc=g:GetFirst()
		if dc:IsType(TYPE_CONTINUOUS) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
	   end
	end
end