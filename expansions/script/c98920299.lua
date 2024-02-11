--真帝王的邪怨
function c98920299.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,98920299+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c98920299.cost)
	e1:SetTarget(c98920299.target)
	e1:SetOperation(c98920299.activate)
	c:RegisterEffect(e1)
end
function c98920299.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c98920299.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup() and c:IsAttackAbove(2400) and c:IsDefense(1000)
end
function c98920299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c98920299.cfilter,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c98920299.cfilter,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function c98920299.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local mg=tc:GetMaterial()
	local vg=mg:GetCount()
	local att=tc:GetAttribute()
	if Duel.IsPlayerCanDraw(tp,vg) and Duel.Draw(tp,vg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c98920299.disfilter,tp,0,LOCATION_MZONE,nil,att)
		local tc=g:GetFirst()
		while tc do
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			  tc:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetCode(EFFECT_DISABLE_EFFECT)
			  e2:SetValue(RESET_TURN_SET)
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			  tc:RegisterEffect(e2)
			  tc=g:GetNext()
		end
	end
end
function c98920299.disfilter(c,att)
	return not c:IsAttribute(att) and c:IsType(TYPE_EFFECT)
end