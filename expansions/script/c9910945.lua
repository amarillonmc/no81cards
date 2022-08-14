--匪魔追缉者 谈判专家
function c9910945.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910945)
	e1:SetCondition(c9910945.spcon)
	e1:SetTarget(c9910945.sptg)
	e1:SetOperation(c9910945.spop)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,9910946)
	e2:SetCondition(c9910945.nacon)
	e2:SetTarget(c9910945.natg)
	e2:SetOperation(c9910945.naop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9910945,ACTIVITY_CHAIN,c9910945.chainfilter)
end
function c9910945.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c9910945.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function c9910945.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910945.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c9910945.negcon)
		e1:SetOperation(c9910945.negop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910945.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE) and Duel.IsChainDisablable(ev)
end
function c9910945.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910945)
	Duel.NegateEffect(ev)
end
function c9910945.nacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c9910945.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910945.naop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.Draw(tp,1,REASON_EFFECT)~=0 and (Duel.GetCustomActivityCount(9910945,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910945,1-tp,ACTIVITY_CHAIN)~=0) then
		local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
end
