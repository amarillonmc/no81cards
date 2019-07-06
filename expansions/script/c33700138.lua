--霓虹车站 ～伪善者烧却之站～
function c33700138.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c33700138.target)
	e1:SetOperation(c33700138.activate)
	c:RegisterEffect(e1)
end
function c33700138.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x443)
end
function c33700138.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c33700138.filter,tp,LOCATION_ONFIELD,0,1,c) end
	local sg=Duel.GetMatchingGroup(c33700138.filter,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c33700138.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33700138.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)  
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
