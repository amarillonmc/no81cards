-- 究极浪漫
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12819100,12819105)
	--tofield
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--actinhand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)
end
function s.condition(e,tp)
	return Duel.IsExistingMatchingCard(s.check,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function s.check(c)
	return c:IsCode(12819105) and c:IsFaceup()
end
function s.pcheck(c)
	return c:IsSetCard(0x3a73) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsFaceupEx()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pcheck,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) 
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function s.mcheck(c)
	return c:IsFaceup() and c:IsSetCard(0x3a73) and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.activate(e,tp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg = Duel.SelectMatchingCard(tp,s.pcheck,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and tc:IsCode(12819100) 
				and Duel.IsExistingMatchingCard(s.mcheck,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.BreakEffect()
				local ct=Duel.GetMatchingGroupCount(s.mcheck,tp,LOCATION_ONFIELD,0,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
				Duel.Destroy(g,REASON_EFFECT)
		   end
		end
	end
end