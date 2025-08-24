--霸瞳天星·滅光
local m=11561069
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11561069,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11561069+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11561069.con)
	e1:SetTarget(c11561069.target1)
	e1:SetOperation(c11561069.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561069,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,11561069+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c11561069.con)
	e2:SetTarget(c11561069.target2)
	e2:SetOperation(c11561069.activate2)
	c:RegisterEffect(e2)
end
function c11561069.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11561069.ssfilter(c)
	return c:IsFacedown()
end
function c11561069.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561069.ssfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(c11561069.chainlm1)
end
function c11561069.chainlm1(e,rp,tp)
	return not e:GetHandler():IsLocation(LOCATION_ONFIELD) or not e:GetHandler():IsFaceup()
end
function c11561069.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetMatchingGroup(c11561069.ssfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)

	local tc2=g2:GetFirst()
	while tc2 do
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetCode(EFFECT_CANNOT_TRIGGER)
		e01:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e01)
		tc2=g2:GetNext()
	end
end
function c11561069.fffilter(c)
	return c:IsFaceup()
end
function c11561069.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561069.fffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(c11561069.chainlm2)
end
function c11561069.chainlm2(e,rp,tp)
	return not e:GetHandler():IsLocation(LOCATION_ONFIELD) or e:GetHandler():IsFaceup()
end
function c11561069.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11561069.fffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end