--大炎蛇 真炎之主
function c35399015.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c35399015.val1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399015,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c35399015.con2)
	e2:SetTarget(c35399015.tg2)
	e2:SetOperation(c35399015.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399015,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,35399015)
	e3:SetCondition(c35399015.con3)
	e3:SetTarget(c35399015.tg3)
	e3:SetOperation(c35399015.op3)
	c:RegisterEffect(e3)
--
end
--
function c35399015.val1(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--
function c35399015.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c35399015.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c35399015.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
--
function c35399015.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function c35399015.tfilter3(c)
	return c:IsFaceup() and not c:IsDisabled()
		and ((c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c35399015.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35399015.tfilter3,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c35399015.op3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c35399015.tfilter3,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()<1 then return end
	for tc in aux.Next(sg) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetType(EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EFFECT_DISABLE)
		e3_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_1)
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_DISABLE_EFFECT)
		e3_2:SetValue(RESET_TURN_SET)
		e3_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3_2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3_3=e3_1:Clone()
			e3_3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3_3)
		end
	end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end