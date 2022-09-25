--术结天缘 水泡放射
function c67200424.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200424+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200424.cost)
	e1:SetTarget(c67200424.target)
	e1:SetOperation(c67200424.activate)
	c:RegisterEffect(e1)  

end
--

function c67200424.excostfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c67200424.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c67200424.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetFieldGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c67200424.excostfilter,tp,LOCATION_ONFIELD,0,1,c) and rt>0 
	end
	local gg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200424.excostfilter,tp,LOCATION_ONFIELD,0,1,gg:GetCount(),c)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gg,1,0,0)
	e:SetLabel(g:GetCount())
end
function c67200424.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	local gg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if gg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,label,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
