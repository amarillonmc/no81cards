--方舟骑士-凯尔希·残余
c29038040.named_with_Arknight=1
function c29038040.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502,29065578)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(423585,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,29038040)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c29038040.sptg)
	e3:SetOperation(c29038040.spop)
	c:RegisterEffect(e3)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,29038041)
	e2:SetCondition(c29038040.atkcon)
	e2:SetTarget(c29038040.atktg)
	e2:SetOperation(c29038040.atkop)
	c:RegisterEffect(e2)
end
function c29038040.filter(c,e,tp)
	return (c:IsCode(c,29065500,29065502,29065578) or aux.IsCodeListed(c,29065500) or aux.IsCodeListed(c,29065502) or aux.IsCodeListed(c,29065578)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29038040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29038040.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29038040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29038040.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29038040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c29038040.atkfilter(c)
	return c:IsFaceup() and c:IsCode(29065578)
end
function c29038040.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c29038040.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c29038040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c29038040.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,1)
		e2:SetValue(1)
		e2:SetCondition(c29038040.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c29038040.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
