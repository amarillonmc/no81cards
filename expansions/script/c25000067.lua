--寂静的山河
function c25000067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25000067.cost)
	e1:SetTarget(c25000067.target)
	e1:SetOperation(c25000067.activate)
	c:RegisterEffect(e1)
end
function c25000067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c25000067.setfilter(c)
	return not c:IsCode(25000067) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c25000067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000067.setfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c25000067.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>ft then ct=ft end
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c25000067.setfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if #sg>0 then
		Duel.SSet(tp,sg)
		for tc in aux.Next(sg) do
			sg:KeepAlive()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetValue(c25000067.aclimit)
			e1:SetTargetRange(1,0)
			e1:SetCondition(c25000067.accon)
			e1:SetLabel(tc:GetCode())
			e1:SetLabelObject(sg)
			Duel.RegisterEffect(e1,tp)
			tc:RegisterFlagEffect(25000067,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(25000067,0))
		end
	end
end
function c25000067.aclimit(e,re,tp)
	local code=e:GetLabel()
	return re:GetHandler():IsCode(code) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c25000067.limitfilter(c)
	return c:GetFlagEffect(25000067)>0 and c:IsFacedown()
end
function c25000067.accon(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	return sg:FilterCount(c25000067.limitfilter,nil)>0
end
