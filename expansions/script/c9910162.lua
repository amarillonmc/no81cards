--战车道计策·先发制人
function c9910162.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910162.cost)
	e1:SetTarget(c9910162.target)
	e1:SetOperation(c9910162.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_LEAVE_GRAVE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910162)
	e2:SetCost(c9910162.setcost)
	e2:SetTarget(c9910162.settg)
	e2:SetOperation(c9910162.setop)
	c:RegisterEffect(e2)
end
function c9910162.cpfilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c9910162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910162.cpfilter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return #g>0 and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,ct,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	e:SetLabel(#sg)
end
function c9910162.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800)
end
function c9910162.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then
		local res=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,res*800,REASON_EFFECT)
	end
end
function c9910162.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c9910162.desfilter(c,tp)
	return Duel.GetSZoneCount(tp,c)>0
end
function c9910162.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910162.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():IsSSetable(true) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910162.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c9910162.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=(#g1==0) and Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) or nil
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg1=g1:Select(tp,1,1,nil)
		if sg1:GetCount()>0 then
			Duel.HintSelection(sg1)
			if Duel.Destroy(sg1,REASON_EFFECT) and c:IsRelateToChain() and Duel.SSet(tp,c)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				c:RegisterEffect(e1)
			end
		end
	elseif g2 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=g2:Select(tp,1,1,nil)
		if sg2:GetCount()>0 then
			Duel.HintSelection(sg2)
			Duel.Destroy(sg2,REASON_EFFECT) 
		end
	end
end
