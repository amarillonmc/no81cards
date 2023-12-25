--人偶·越一弥心
function c74516146.initial_effect(c)
	aux.EnableDualAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74516146,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c74516146.con1)
	e1:SetCost(c74516146.descost1)
	e1:SetTarget(c74516146.destg)
	e1:SetOperation(c74516146.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74516146.con2)
	e2:SetCost(c74516146.descost2)
	c:RegisterEffect(e2)
end
function c74516146.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74516146.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c74516146.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74516146.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74516146.desfilter(c,g)
	return g:IsContains(c)
end
function c74516146.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c74516146.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c74516146.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c74516146.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
