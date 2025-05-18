--披灰之魔姬 仙度瑞拉
function c95101020.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,c95101020.uqfilter,LOCATION_MZONE)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c95101020.sprcon)
	e1:SetOperation(c95101020.sprop)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c95101020.disop)
	c:RegisterEffect(e2)
end
function c95101020.uqfilter(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),95101028) then
		return c:IsCode(95101020)
	else
		return c:IsSetCard(0xbba)
	end
end
function c95101020.gcheck(g)
	return g:Filter(Card.IsType,nil,TYPE_SPELL)==5 and g:Filter(Card.IsType,nil,TYPE_TRAP)==5
end
function c95101020.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_GRAVE,nil)
	return g:CheckSubGroup(c95101020.gcheck,10,10)
end
function c95101020.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_GRAVE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c95101020.gcheck,false,10,10)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c95101020.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_MONSTER) or rp==tp or not re:IsActivated() then return end
	Duel.Hint(HINT_CARD,0,95101020)
	Duel.NegateEffect(ev)
end
