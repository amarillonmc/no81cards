--人理之诗 红莲之圣女
function c22020480.initial_effect(c)
	aux.AddCodeList(c,22020410)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22020480.cost)
	e1:SetCountLimit(1,22020480+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22020480.damop)
	c:RegisterEffect(e1)
end
function c22020480.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-100) end
	Duel.SelectOption(tp,aux.Stringid(22020480,1))
	Duel.PayLPCost(tp,lp-100)
end
function c22020480.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22020480.dfilter(c)
	return c:IsFaceup() and c:IsCode(22020410)
end
function c22020480.damop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c22020480.desfilter,tp,0,LOCATION_MZONE,nil)
	local dg1=Duel.GetMatchingGroup(c22020480.dfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	if dg:GetCount()>0 and dg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22020480,0)) then
		Duel.BreakEffect()
		Duel.SelectOption(tp,aux.Stringid(22020480,2))
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		local ct1=Duel.Destroy(dg1,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end