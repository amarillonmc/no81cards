--龙腾无人机衍生物-武装打击模块
function c79029084.initial_effect(c)
	c:SetUniqueOnField(1,0,79029084) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdogcon)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029084.target)
	e2:SetOperation(c79029084.operation)
	c:RegisterEffect(e2)
end
function c79029084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c79029084.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	local a=g:RandomSelect(tp,1)
	Duel.Remove(a,POS_FACEUP,REASON_EFFECT)
end
	


