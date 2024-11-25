--X程序
function c16364017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16364017.destg)
	e1:SetOperation(c16364017.desop)
	c:RegisterEffect(e1)
end
function c16364017.desfilter(c)
	return not c:IsSetCard(0xdc3) or c:IsFacedown()
end
function c16364017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(c16364017.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16364017.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c16364017.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif ct>=5 then
		local g=Duel.GetMatchingGroup(c16364017.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end