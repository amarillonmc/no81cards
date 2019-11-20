--奥义！瞬闪轰爆破！
function c33401315.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33401315+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33401315.condition)
	e1:SetTarget(c33401315.destg)
	e1:SetOperation(c33401315.desop)
	c:RegisterEffect(e1)
end
function c33401315.cfilter(c,tp)
	return c:IsFaceup()  and c:IsCode(33401309)
end
function c33401315.condition(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.IsExistingMatchingCard(c33401315.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33401315.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33401315.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end