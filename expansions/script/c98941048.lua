--多元影依的回转
function c98941048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98941048)
	e1:SetTarget(c98941048.tgtg)
	e1:SetOperation(c98941048.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(c98941048.cost)
	c:RegisterEffect(e2)
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD)
	e30:SetCode(EFFECT_ACTIVATE_COST)
	e30:SetRange(LOCATION_DECK)
	e30:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e30:SetTargetRange(1,0)
	e30:SetLabelObject(e2)
	e30:SetTarget(c98941048.actarget1)
	e30:SetOperation(c98941048.costop1)
	c:RegisterEffect(e30)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e3)
end
function c98941048.actarget1(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c98941048.costop1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c98941048.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c98941048.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function c98941048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsLocation(LOCATION_DECK) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98941048.filter2(c)
	return c:IsSetCard(0x9d) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsCode(98941048) 
end
function c98941048.tgfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98941048.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941048.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c98941048.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c98941048.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCost(c98941048.costchk)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c98941048.actarget)
		e1:SetOperation(c98941048.costop)
		Duel.RegisterEffect(e1,tp)
		local g=Duel.GetMatchingGroup(c98941048.filter2,tp,0xff,0,nil)
		for tc in aux.Next(g) do
			local e2=tc:GetActivateEffect():Clone()
			e2:SetProperty(tc:GetActivateEffect():GetProperty(),EFFECT_FLAG2_COF)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetLabelObject(c)
			e2:SetRange(LOCATION_DECK)
			tc:RegisterEffect(e2)
		end
	end
end
function c98941048.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(c98941048.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c98941048.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(tc)
	return tc:IsSetCard(0x9d) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_DECK)
end
function c98941048.tdfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c98941048.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98941048.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	local tc=e:GetLabelObject()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--oath effects
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98941048.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941048.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_DECK) and re:GetHandler():IsCode(e:GetHandler():GetCode())
end