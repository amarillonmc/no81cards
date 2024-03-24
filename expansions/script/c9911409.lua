--破阵前驱 T-90M
function c9911409.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c9911409.ovfilter,aux.Stringid(9911409,0),2,c9911409.xyzop)
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c9911409.atcost)
	e2:SetOperation(c9911409.atop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c9911409.distg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(c9911409.discon)
	e4:SetOperation(c9911409.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c9911409.distg)
	c:RegisterEffect(e5)
end
function c9911409.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c9911409.ovfilter(c)
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and g:IsExists(c9911409.filter,3,nil)
end
function c9911409.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9911409.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHandAsCost()
end
function c9911409.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(c9911409.costfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end
function c9911409.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911409.costfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c9911409.disfilter(c,code)
	return c:GetTurnID()==Duel.GetTurnCount() and bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:IsOriginalCodeRule(code)
end
function c9911409.distg(e,c)
	local code=c:GetOriginalCodeRule()
	return c~=e:GetHandler()
		and Duel.IsExistingMatchingCard(c9911409.disfilter,e:GetHandlerPlayer(),0,LOCATION_GRAVE,1,nil,code)
end
function c9911409.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCodeRule()
	return re:GetHandler()~=e:GetHandler()
		and Duel.IsExistingMatchingCard(c9911409.disfilter,tp,0,LOCATION_GRAVE,1,nil,code)
end
function c9911409.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
