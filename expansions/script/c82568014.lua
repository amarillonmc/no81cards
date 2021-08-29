--逆方舟骑士·秽壤血脉 泥岩
function c82568014.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0x825),aux.Tuner(nil),nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--EFFECT target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c82568014.atlimit)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c82568014.valcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c82568014.ctcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(82568014,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,82568014)
	e6:SetCondition(c82568014.discon)
	e6:SetCost(c82568014.discost)
	e6:SetTarget(c82568014.distg)
	e6:SetOperation(c82568014.disop)
	c:RegisterEffect(e6)
end
function c82568014.atlimit(e,c)
	return c~=e:GetHandler()
end
function c82568014.ctcon(e,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c82568014.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c82568014.rfilter(c,e,tp,ft)
	return (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsRace(RACE_ROCK)) and c:IsReleasable()
end
function c82568014.grandcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp 
end
function c82568014.grandcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckReleaseGroup(tp,c82568014.rfilter,1,e:GetHandler(),e,tp,ft) 
						or Duel.CheckReleaseGroup(1-tp,c82568014.rfilter,1,e:GetHandler(),e,tp,ft)) end
	local g=Duel.SelectMatchingCard(tp,c82568014.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())
	Duel.Release(g,REASON_COST)
end
function c82568014.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(atk)
	c:RegisterEffect(e2)
	  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetValue(c82568014.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c82568014.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82568014.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c82568014.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if  re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c82568014.disop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateEffect(ev)
	  Duel.Destroy(eg,REASON_EFFECT)
	 if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568015,0,0x4011,0,2000,3,RACE_ROCK,ATTRIBUTE_EARTH) and  e:GetHandler():IsRelateToEffect(e) 
	 and  Duel.SelectYesNo(tp,aux.Stringid(82568014,3)) then 
	local token=Duel.CreateToken(tp,82568015)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
end
function c82568014.discon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c82568014.disop2(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateAttack(ev) 
	 if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82568015,0,0x4011,0,2000,3,RACE_ROCK,ATTRIBUTE_EARTH) and  e:GetHandler():IsRelateToEffect(e) 
	 and  Duel.SelectYesNo(tp,aux.Stringid(82568014,3)) then 
	local token=Duel.CreateToken(tp,82568015)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
end