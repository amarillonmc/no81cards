--狂暴轮回狂暴
function c67201212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1) 
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201212,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201212,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c67201212.target)
	e3:SetOperation(c67201212.operation)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67201212,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,67201212)
	e4:SetTarget(c67201212.settg)
	e4:SetOperation(c67201212.setop)
	c:RegisterEffect(e4)	 
end
--
function c67201212.costfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c67201212.setfilter(c)   
	if not (c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return c:IsSSetable() or (ft>0 and bit.band(c:GetType(),0x20004)==0x20004 and not c:IsForbidden())
end
function c67201212.thfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c67201212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201212.costfilter,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(c67201212.setfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c67201212.costfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(c67201212.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c67201212.costfilter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(c67201212.costfilter,tp,LOCATION_ONFIELD,0,c)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		e:SetLabel(1)
		e:SetCategory(0)
	end
	if tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c67201212.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201212.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsSSetable() and (not bit.band(tc:GetType(),0x20004)==0x20004 or ft<=0 or (not tc:IsForbidden()) or Duel.SelectOption(tp,1153,aux.Stringid(67201212,2))==0) then
				Duel.SSet(tp,tc)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
	if label==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201212.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
--
function c67201212.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c67201212.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
