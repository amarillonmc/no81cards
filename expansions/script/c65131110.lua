--净火
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return true
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,dg:GetCount(),e:GetHandler())
	local tc=cg:GetFirst()
	local ctype=0
	while tc do
		for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
		end
		tc=cg:GetNext()
	end
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoGrave(cg,REASON_COST)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chlimit(ctype))
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,cg:GetCount(),0,0)
end
function s.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,count,count,nil)
	if g:GetCount()==count then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.setfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x836)
end
function s.ccfilter(c)
	return bit.band(c:GetType(),0x7)
end
function s.fselect(g)
	return g:GetClassCount(s.ccfilter)==g:GetCount()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_GRAVE,0,e:GetHandler()):CheckSubGroup(s.fselect,3,3) end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.fselect,false,3,3)
	if sg and sg:GetCount()==3 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end