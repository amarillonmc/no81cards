--神帝的霸炎
local m=16110028
local cm=_G["c"..m]
function cm.initial_effect(c)
		--Get control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.setcost)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsSetCard(0xcc5)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.locfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE)
end
function cm.filter(g,ct,ct1)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=ct and g:FilterCount(cm.locfilter,nil)<=ct1
end
function cm.filter2(c,ct,ct1)
	return c:IsAbleToChangeControler() and ((c:IsLocation(LOCATION_MZONE) and ct>0) or (c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE) and ct1>0) or c:IsLocation(LOCATION_FZONE))
end
function cm.ctlfilter(c,ct,ct1)
	return c:IsAbleToChangeControler()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct2=Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)
	local g=Duel.GetMatchingGroup(cm.ctlfilter,tp,0,LOCATION_ONFIELD,nil)
	if chkc then return cm.filter(chkc,ct1,ct2) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_ONFIELD,1,nil,ct1,ct2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:SelectSubGroup(tp,cm.filter,false,1,2,ct1,ct2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc,tc1=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc,tp)
		elseif tc:IsLocation(LOCATION_FZONE) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pos=tc:GetPosition()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,pos,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				local pos=tc:GetPosition()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,pos,true)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
	if tc1 and tc1:IsRelateToEffect(e) then
		if tc1:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc1,tp)
		elseif tc1:IsLocation(LOCATION_FZONE) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pos=tc1:GetPosition()
			Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,pos,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				local pos=tc1:GetPosition()
				Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,pos,true)
			else
				Duel.SendtoGrave(tc1,REASON_RULE)
			end
		end
	end
end
function cm.cfilter1(c)
	return c:IsSetCard(0xcc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.rmlimit)
	e1:SetLabel(code)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rmlimit(e,c,tp,r,re)
	return c:IsCode(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(m) and r==REASON_COST
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end