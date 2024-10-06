--狂暴轮回者-『狼』
function c67201210.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,c67201210.matfilter,2,3)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c67201210.matval)
	c:RegisterEffect(e0) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201210,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67201210.target)
	e3:SetOperation(c67201210.operation)
	c:RegisterEffect(e3)	  
end
function c67201210.matfilter(c)
	return c:IsLinkSetCard(0x567b) or (c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP))
end
function c67201210.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
--
function c67201210.costfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c67201210.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201210.costfilter,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c67201210.costfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c67201210.costfilter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(c67201210.costfilter,tp,LOCATION_ONFIELD,0,nil)
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
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	if tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabel(2)
		e:SetCategory(0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c67201210.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if label==2 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetCondition(c67201210.thcon)
		e4:SetOperation(c67201210.thop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c67201210.thfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP)
end
function c67201210.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function c67201210.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67201210)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end