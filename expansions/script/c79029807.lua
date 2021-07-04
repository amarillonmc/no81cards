--逆元构造 脉冲
function c79029807.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,2,nil,nil,99)
	c:EnableReviveLimit() 
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029807,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,79029807)
	e1:SetCondition(c79029807.drcon)
	e1:SetTarget(c79029807.drtg)
	e1:SetOperation(c79029807.drop)
	c:RegisterEffect(e1) 
	--add cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029807,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,19029807)
	e2:SetCost(c79029807.cost2) 
	e2:SetCondition(c79029807.condition2)
	e2:SetTarget(c79029807.target2)
	e2:SetOperation(c79029807.activate)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29029807)
	e3:SetCondition(c79029807.condition)
	e3:SetOperation(c79029807.op)
	c:RegisterEffect(e3)
end
function c79029807.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029807.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029807.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029807.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
		end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029807.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c79029807.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029807.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(1-tp,79029807,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c79029807.costchk)
	e1:SetOperation(c79029807.costop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029807.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,79029807)
	return Duel.CheckLPCost(tp,ct*800)
end
function c79029807.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end
function c79029807.condfil(c,tp)
	return c:GetPreviousControler()==tp and c:IsSetCard(0xa991)
end
function c79029807.condition(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	local chc=chain:GetHandler()
	return Duel.GetCurrentChain()>1 and c79029807.condfil(chc,tp) and rp~=tp and e:GetHandler():IsAbleToRemove()
end
function c79029807.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(79029807,2)) then
		if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) then
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		end
	end
end