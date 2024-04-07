--神裁权 - 三王鼎立
function c7210014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,7210014)
	e1:SetCondition(c7210014.condition)
	e1:SetTarget(c7210014.target)
	e1:SetOperation(c7210014.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7210014)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c7210014.detg)
	e2:SetOperation(c7210014.deop)
	c:RegisterEffect(e2)
end
function c7210014.filter(c)
	return c:IsCode(7210018) and c:IsFaceup()
end
function c7210014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c7210014.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c7210014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c7210014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c7210014.defilter(tp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,7210006)
	local g1=Group.CreateGroup()
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if tc:GetColumnGroup():GetCount()>0 then g1:Merge(tc:GetColumnGroup()) end
			tc=g:GetNext()
		end
	end
	return g1
end
function c7210014.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c7210014.defilter(tp):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c7210014.defilter(tp),c7210014.defilter(tp):GetCount(),0,0)
end
function c7210014.deop(e,tp,eg,ep,ev,re,r,rp)
	if c7210014.defilter(tp):GetCount()>0 then
		local g=c7210014.defilter(tp)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
