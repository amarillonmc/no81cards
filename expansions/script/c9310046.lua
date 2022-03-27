--荒野的单调士
function c9310046.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9310046)
	e1:SetLabel(0)
	e1:SetCost(c9310046.cost)
	e1:SetTarget(c9310046.tg)
	e1:SetOperation(c9310046.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c9310046.tnval)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c9310046.efcon)
	e4:SetOperation(c9310046.efop)
	c:RegisterEffect(e4)
end
function c9310046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9310046.cfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c9310046.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9310046.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9310046.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c9310046.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabelObject():GetOriginalCodeRule()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,code))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,code))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9310046.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310046.efcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_SYNCHRO+REASON_LINK)~=0
end
function c9310046.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9310046,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9310046.reptg)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c9310046.repfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave() and c:IsFaceup()
end
function c9310046.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c9310046.repfilter,tp,LOCATION_REMOVED,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(9310046,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.GetMatchingGroup(c9310046.repfilter,tp,LOCATION_REMOVED,0,nil)
		local tc=g:GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN+REASON_REPLACE)
		if tc:IsType(TYPE_EQUIP) and tc:IsType(TYPE_SPELL) 
		   and tc:IsAbleToHand() and tc:IsLocation(LOCATION_GRAVE) 
		   and Duel.SelectYesNo(tp,aux.Stringid(9310046,2)) then
		   Duel.BreakEffect()
		   Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		return true
	else return false end
end