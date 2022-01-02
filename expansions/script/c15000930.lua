local m=15000930
local cm=_G["c"..m]
cm.name="死之花盛放的大地"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x3f3f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToGraveAsCost() and not c:IsCode(15000930)) then return false end
	local te1=c.deadrose_effect_three
	if not te1 then return false end
	local te2=c.deadrose_effect_onfield_splimit
	local te3=c.deadrose_effect_onfield_slimit
	local te4=c.deadrose_effect_onfield
	if not (te2 or te3 or te4) then return false end
	local tg1=te1:GetTarget()
	return not tg1 or tg1 and tg1(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.efffilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.efffilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local te=tc.deadrose_effect_three
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	local te=tc.deadrose_effect_three
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	local te2=tc.deadrose_effect_onfield_splimit
	local te3=tc.deadrose_effect_onfield_slimit
	local te4=tc.deadrose_effect_onfield
	if te2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if te3 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(cm.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if te4 then
		local e4=Effect.CreateEffect(e:GetHandler())
		if te4:GetType() then e4:SetType(te4:GetType()) end
		if te4:GetCode() then e4:SetCode(te4:GetCode()) end
		if te4:GetProperty() then e4:SetProperty(te4:GetProperty()) end
		if tc:IsOriginalCodeRule(15000921) then e4:SetTargetRange(1,1)
			elseif tc:IsOriginalCodeRule(15000923) then e4:SetTargetRange(1,0) end
		if te4:GetCondition() then e4:SetCondition(te4:GetCondition()) end
		if te4:GetTarget() then e4:SetTarget(te4:GetTarget()) end
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.splimit(e,c)
	return c:IsSetCard(0x3f3f)
end