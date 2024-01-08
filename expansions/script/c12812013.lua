--究极浪漫
local m=12812013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp)
	return Duel.IsExistingMatchingCard(cm.check,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function cm.check(c)
	return c:IsCode(12812002) and c:IsFaceup()
end
function cm.pcheck(c)
	return c:IsSetCard(0xa73) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pcheck,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function cm.mcheck(c)
	return c:IsFaceup() and c:IsSetCard(0xa73)
end
function cm.activate(e,tp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg = Duel.SelectMatchingCard(tp,cm.pcheck,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc = sg:GetFirst()
			if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and tc:IsCode(12812001) and Duel.IsExistingMatchingCard(cm.mcheck,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				local ct = Duel.GetMatchingGroupCount(cm.mcheck,tp,LOCATION_MZONE,0,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g = Duel.SelectMatchingCard(tp,nil,1-tp,LOCATION_ONFIELD,0,1,ct,nil)
				Duel.Destroy(g,REASON_EFFECT)
		   end
		end
	end
end