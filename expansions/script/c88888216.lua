--CAN:D 纷蕾雅
function c88888216.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8908),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888216,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,88888216)
	e1:SetCost(c88888216.imcost)
	e1:SetTarget(c88888216.imtg)
	e1:SetOperation(c88888216.imop)
	c:RegisterEffect(e1)
	--adjust(disablecheck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0xff)
	e2:SetLabelObject(e1)
	e2:SetOperation(c88888216.adjustop)
	c:RegisterEffect(e2)
	--battle remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c88888216.imfilter(c)
	return c:IsSetCard(0x8908) and c:IsFaceup()
end
function c88888216.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local mg=e:GetHandler():GetOverlayGroup()
	e:SetLabel(mg:GetCount())
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>0 and Duel.IsPlayerAffectedByEffect(tp,88888217) and Duel.SelectYesNo(tp,aux.Stringid(88888217,1)) then
		local sg=mg:Select(tp,1,ct,nil)
		if #sg~=0 then
			for sc in aux.Next(sg) do
				Duel.MoveToField(sc,tp,sc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				sc:RegisterEffect(e1)
				mg:Sub(Group.FromCards(sc))
			end
		end
	end
	if #mg>0 then e:GetHandler():RemoveOverlayCard(tp,#mg,#mg,REASON_COST) end
end
function c88888216.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888216.imfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c88888216.imop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88888216.imfilter,tp,LOCATION_ONFIELD,0,nil)
	local nc=g:GetFirst()
	while nc do
		if nc:IsLocation(LOCATION_MZONE) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_CHAIN)
			e3:SetValue(c88888216.efilter)
			e3:SetOwnerPlayer(tp)
			nc:RegisterEffect(e3)
		elseif nc:IsLocation(LOCATION_SZONE) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_CHAIN)
			e3:SetValue(c88888216.efilter)
			e3:SetOwnerPlayer(tp)
			nc:RegisterEffect(e3)
		end
		nc=g:GetNext()
	end
	if e:GetLabel()<3 then return end
	for i=1,ev do
		local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then Duel.NegateEffect(ev) end
	end
end
function c88888216.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c88888216.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local ct=Duel.GetMatchingGroupCount(c88888216.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function c88888216.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end