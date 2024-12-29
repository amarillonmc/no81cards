--赠礼的嫉妒妖怪
function c22348447.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+22348447)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c22348447.atkcon)
	e1:SetTarget(c22348447.atktg)
	e1:SetOperation(c22348447.atkop)
	c:RegisterEffect(e1)
	aux.RegisterMergedDelayedEvent(c,22348447,EVENT_SPSUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,22348447,EVENT_SUMMON_SUCCESS)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22348447.condition)
	e2:SetValue(c22348447.atkval)
	c:RegisterEffect(e2)
	--damage change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348447.recon)
	e3:SetOperation(c22348447.reop)
	c:RegisterEffect(e3)
end
function c22348447.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c22348447.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c22348447.chkfilter,tp,0,LOCATION_MZONE,1,nil,tp,c:GetSequence())
end
function c22348447.chkfilter(c,tp,seq)
	local sseq=c:GetSequence()
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and sseq==seq
	end
	if sseq<5 then
		return math.abs(sseq-seq)==1
	end
	if sseq>=5 then
		return sseq==5 and seq==1 or sseq==6 and seq==3
	end
end
function c22348447.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(c22348447.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	if #g==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348447.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc,true)
		end
	end
end
function c22348447.condition(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c22348447.atkval(e,c)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(c22348447.chkfilter,tp,0,LOCATION_ONFIELD,nil,tp,tc:GetSequence())
	return ct*c:GetBaseAttack()
end
function c22348447.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()<c:GetAttack()
end
function c22348447.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	Duel.Recover(tp,c:GetAttack()-bc:GetAttack(),REASON_EFFECT)
end
