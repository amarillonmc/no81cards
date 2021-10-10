--魔戒仪士咆哮魔剑-牙狼
function c82599995.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82599995)
	e1:SetCost(c82599995.cost)
	e1:SetTarget(c82599995.destg)
	e1:SetOperation(c82599995.desop)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c82599995.pocon)
	e2:SetTarget(c82599995.potg)
	e2:SetOperation(c82599995.poop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c82599995.retreg)
	c:RegisterEffect(e3)
end
function c82599995.pocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
end
function c82599995.grfilter(c,e,tp)
	return c:IsSetCard(0x821) and c:IsFaceup()
end
function c82599995.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c82599995.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) 
	and Duel.IsExistingMatchingCard(c82599995.grfilter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.GetTurnPlayer()~=tp end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82599995.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c82599995.filter(c,g)
	return c:IsFaceup() 
end 
function c82599995.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c82599995.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	Duel.SetChainLimit(c82599995.chlimit)
end
function c82599995.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsFaceup() and c:IsRelateToEffect(e) then
	local g=Duel.GetMatchingGroup(c82599995.filter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
end
function c82599995.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c82599995.retcon)
	e1:SetTarget(c82599995.rettg)
	e1:SetOperation(c82599995.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c82599995.retcon2)
	c:RegisterEffect(e2)
end
function c82599995.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function c82599995.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) 
end
function c82599995.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,82599981,0,0x4011,2500,2000,9,RACE_WARRIOR,ATTRIBUTE_LIGHT)
			  and Duel.IsPlayerCanDraw(tp,2) 
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(c82599995.chlimit)
end
function c82599995.thfilter(c,e,tp)
	return ((c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)) or c:IsSetCard(0x821)) and c:IsAbleToHand()
end
function c82599995.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82599981,0,0x4011,2500,2000,9,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,82599981)
			if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local h1=Duel.Draw(tp,2,REASON_EFFECT)
	if h1>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	end
end
end
function c82599995.chlimit(e,ep,tp)
	return tp==ep
end

