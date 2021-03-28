--人理之诗 花开堪折直须折
function c22020620.initial_effect(c)
	aux.AddCodeList(c,22020610)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22020620.target0)
	e1:SetOperation(c22020620.activate0)
	c:RegisterEffect(e1)
	--time
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22020620.condition)
	e2:SetTarget(c22020620.sptg1)
	e2:SetOperation(c22020620.activate)
	c:RegisterEffect(e2)
end
function c22020620.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020611,0,0x4011,1200,1200,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22020620.activate0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22020611,0,0x4011,1200,1200,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then return end
	local token=Duel.CreateToken(tp,22020611)
	Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
end
function c22020620.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22020620.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c22020620.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
	--
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c22020620.atktg)
	e3:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e3,tp)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(1200)
	e4:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e4,tp)
end
function c22020620.atktg(e,c)
	return not c:IsCode(22020610)
end