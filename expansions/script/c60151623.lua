--居于世界的真理
function c60151623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60151623.condition)
	e1:SetTarget(c60151623.target)
	e1:SetOperation(c60151623.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCondition(c60151623.setcon)
	e2:SetTarget(c60151623.settg)
	e2:SetOperation(c60151623.setop)
	c:RegisterEffect(e2)
end
function c60151623.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsRace(RACE_FAIRY) 
end
function c60151623.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60151623.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151623.filter2(c)
	return c:IsFaceup() and c:IsAbleToRemove() 
end
function c60151623.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151623.filter2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,1,nil) and d>0 end
end
function c60151623.activate(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60151623.filter2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,1,d,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tc=g:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_REMOVED) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(0,1)
				e1:SetValue(c60151623.aclimit)
				e1:SetLabel(tc:GetCode())
				if Duel.GetTurnPlayer()~=tp then
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				end
				Duel.RegisterEffect(e1,tp)
			end
			tc=g:GetNext()
		end
	end
end
function c60151623.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c60151623.cfilter(c,tp)
	return c:IsFaceup() and c:GetAttack()>0
end
function c60151623.setcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60151623.cfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	local atk=g:GetSum(Card.GetAttack)
	return atk>Duel.GetLP(tp)
end
function c60151623.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsSSetable() and c:GetFlagEffect(60151623)==0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	c:RegisterFlagEffect(60151623,RESET_CHAIN,0,1)
end
function c60151623.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end