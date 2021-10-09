--fate·卫宫士郎-剑之意志
function c9950561.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),5,3,c9950561.ovfilter,aux.Stringid(9950561,1))
 --ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950561.atkval)
	c:RegisterEffect(e1)
	--Direct Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(c9950561.raval)
	c:RegisterEffect(e3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950561.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
 --immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950561,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9950561.cost)
	e1:SetOperation(c9950561.operation)
	c:RegisterEffect(e1)
end
function c9950561.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9950557)
end
function c9950561.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950561,0))
end
function c9950561.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c9950561.raval(e,c)
	local oc=e:GetHandler():GetOverlayCount()
	return math.max(0,oc-1)
end
function c9950561.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950561.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba6)
end
function c9950561.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950561.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9950561.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950561,0))
end
function c9950561.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end