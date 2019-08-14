--弧光天使-爱莎
function c60150814.initial_effect(c)
	c:SetUniqueOnField(1,1,60150814)
	--xyz summon
	aux.AddXyzProcedure(c,c60150814.mfilter,8,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e111=Effect.CreateEffect(c)
	e111:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e111:SetType(EFFECT_TYPE_SINGLE)
	e111:SetCode(EFFECT_SPSUMMON_CONDITION)
	e111:SetValue(c60150814.splimit)
	c:RegisterEffect(e111)
	--Attribute Dark
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_ADD_ATTRIBUTE)
	e12:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_OVERLAY)
	e12:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e12)
	--特招免疫
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c60150814.hspcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c60150814.hspcon)
	e2:SetOperation(c60150814.sumsuc)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150814,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c60150814.negcon)
	e3:SetOperation(c60150814.negop)
	c:RegisterEffect(e3)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(60150814,1))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c60150814.target)
	e8:SetCost(c60150814.tdcost2)
	e8:SetOperation(c60150814.tgop)
	c:RegisterEffect(e8)
end
function c60150814.mfilter(c)
	return c:IsSetCard(0x3b23)
end
function c60150814.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c60150814.cfilter(c)
	return c:IsFaceup() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c60150814.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	and Duel.IsExistingMatchingCard(c60150814.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150814.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150814.tfilter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function c60150814.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and (chkc:IsAbleToRemove() or chkc:IsAbleToGrave()) end
	if chk==0 then return Duel.IsExistingTarget(c60150814.tfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150814.tfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,g,1,0,0)
end
function c60150814.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60150814.tfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150814,1))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			if Duel.SelectYesNo(tp,aux.Stringid(60150814,2)) then
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c60150814.filter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c60150814.chainlm(e,rp,tp)
	return tp==rp
end
function c60150814.hspcon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60150814.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,5,nil)
end 
function c60150814.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_XYZ then return end
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c60150814.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(60150814,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60150814.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
		and Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=5
end
function c60150814.filter2(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c60150814.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60150814.filter2,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c60150814.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60150814.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end