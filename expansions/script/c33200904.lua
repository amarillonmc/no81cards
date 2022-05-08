--寒霜灵兽 暴风雪
function c33200904.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33200904+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200904.condition)
	e1:SetTarget(c33200904.target)
	e1:SetOperation(c33200904.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33210904)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c33200904.imop)
	c:RegisterEffect(e2)
end

function c33200904.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200900)>0
end
function c33200904.desfilter(c)
	return c:GetCounter(0x132a)>0
end
function c33200904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c33200904.desfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c33200904.desfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,nil,0,0x132a)
end
function c33200904.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33200904.desfilter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(Card.IsCanAddCounter,c,0x132a,1)
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x132a,1) then
			tc:AddCounter(0x132a,1)
		end
	end
end

--e2
function c33200904.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e1:SetOperation(c33200904.disop)
	Duel.RegisterEffect(e1,tp)
end
function c33200904.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c33200904.chlimit)
end
function c33200904.chlimit(e,ep,tp)
	return tp==ep or e:GetHandler():GetCounter(0x132a)==0
end