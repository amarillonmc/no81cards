--人理之基 阿塔兰忒
function c22021020.initial_effect(c)
	aux.AddCodeList(c,22020940)
	--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22021020,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c22021020.ntcon)
	e0:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021020,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c22021020.descost)
	e2:SetTarget(c22021020.destg)
	e2:SetOperation(c22021020.desop)
	c:RegisterEffect(e2)
end
function c22021020.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020940)
end
function c22021020.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22021020.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c22021020.filter(c)
	return c:IsSetCard(0x3ff1) and c:IsDiscardable()
end
function c22021020.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021020.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22021020.filter,1,1,REASON_COST+REASON_DISCARD)
	Duel.SelectOption(tp,aux.Stringid(22021020,2))
end
function c22021020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22021020.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SelectOption(tp,aux.Stringid(22021020,3))
	Duel.Destroy(g,REASON_EFFECT)
end