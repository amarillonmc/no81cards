--沧海姬的喷薄
function c9911014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911014+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911014.target)
	e1:SetOperation(c9911014.activate)
	c:RegisterEffect(e1)
end
function c9911014.rlfilter(c,tp)
	local loc=0
	if c:IsLocation(LOCATION_HAND) then loc=LOCATION_HAND end
	if c:IsLocation(LOCATION_MZONE) then loc=LOCATION_ONFIELD end
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect() and Duel.GetFieldGroupCount(tp,0,loc)>0
end
function c9911014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9911014.rlfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD)
end
function c9911014.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function c9911014.filter1(c)
	return c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x6954) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911014.filter2(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x6954) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c9911014.disfilter(c)
	local b1=c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
	local b2=c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED+LOCATION_EXTRA) and c:IsFaceup())
	return b1 or b2
end
function c9911014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(c9911014.rlfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,c9911014.fselect,false,1,2)
	if #g==0 then return end
	local lab=0
	if g:IsExists(c9911014.filter1,1,nil) then lab=lab+1 end
	if g:IsExists(c9911014.filter2,1,nil) then lab=lab+2 end
	Duel.HintSelection(g)
	Duel.Release(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if #og==0 then return end
	local sg=Group.CreateGroup()
	if og:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		sg:Merge(sg1)
	elseif lab==1 or lab==3 then
		lab=lab-1
	end
	if og:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	elseif lab==2 or lab==3 then
		lab=lab-2
	end
	if #sg==0 or Duel.Destroy(sg,REASON_EFFECT)==0 then return end
	local dg=Duel.GetOperatedGroup():Filter(c9911014.disfilter,nil)
	if (lab==1 or lab==3) and c:IsRelateToEffect(e) and c:IsCanTurnSet()
		and Duel.SelectYesNo(tp,aux.Stringid(9911014,0)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	if (lab==2 or lab==3) and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911014,1)) then
		Duel.BreakEffect()
		for sc in aux.Next(dg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(c9911014.distg)
			e1:SetLabelObject(sc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c9911014.discon)
			e2:SetOperation(c9911014.disop)
			e2:SetLabelObject(sc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c9911014.distg)
			e3:SetLabelObject(sc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c9911014.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9911014.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9911014.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
