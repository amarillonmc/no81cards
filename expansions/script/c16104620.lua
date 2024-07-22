--异种 蛟
function c16104620.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,4)
	aux.AddXyzProcedureLevelFree(c,c16104620.mfilter,nil,3,3)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16104620,2))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16104620)
	e1:SetCondition(c16104620.condition)
	e1:SetCost(c16104620.cost)
	e1:SetTarget(c16104620.target)
	e1:SetOperation(c16104620.operation)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16104620,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98500206)
	e2:SetCondition(c16104620.copcon)
	e2:SetOperation(c16104620.copop)
	c:RegisterEffect(e2)
	--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16104620,4))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98500207)
	e3:SetCost(c16104620.cost2)
	e3:SetTarget(c16104620.postg)
	e3:SetOperation(c16104620.posop)
	c:RegisterEffect(e3)
end
function c16104620.mfilter(c)
	return c:IsType(TYPE_FLIP)
end
function c16104620.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c16104620.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(16104620,9),aux.Stringid(16104620,10))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c16104620.filter(c)
	return c:IsPosition(POS_FACEDOWN)
end
function c16104620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16104620.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c16104620.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c16104620.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c16104620.copfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c16104620.copcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c16104620.copfilter,1,nil)
end
function c16104620.copop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(c16104620.copfilter,nil)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		tc=g:GetNext()
	end
end
function c16104620.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16104620.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c16104620.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16104620.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16104620.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c16104620.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c16104620.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 and tc:GetControler()==1-tp then
			if Duel.SelectYesNo(tp,aux.Stringid(16104620,5)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local tc2=Duel.SelectMatchingCard(tp,c16104620.posfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
				Duel.ChangePosition(tc2,POS_FACEDOWN_DEFENSE)
			end
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
