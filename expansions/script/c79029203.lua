--罗德岛·特种干员-傀影
function c79029203.initial_effect(c)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21123811,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c79029203.discon)
	e2:SetCost(c79029203.cost)
	e2:SetTarget(c79029203.distg)
	e2:SetOperation(c79029203.disop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21123811,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCondition(c79029203.dscon)
	e3:SetCost(c79029203.cost)
	e3:SetTarget(c79029203.dstg)
	e3:SetOperation(c79029203.dsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	--negate attack
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21123811,2))
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCountLimit(1)
	e6:SetCondition(c79029203.negcon)
	e6:SetCost(c79029203.cost)
	e6:SetOperation(c79029203.negop)
	c:RegisterEffect(e6)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c79029203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function c79029203.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0)
end
function c79029203.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029203.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	if Duel.Destroy(eg,REASON_EFFECT) and Duel.IsPlayerCanSpecialSummonMonster(tp,79029206,nil,nil,2000,2000,10,RACE_CYBERSE,ATTRIBUTE_DARK) then
	local x=Duel.CreateToken(tp,79029206)
	Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c79029203.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and (not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0)
end
function c79029203.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c79029203.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT) and Duel.IsPlayerCanSpecialSummonMonster(tp,79029205,nil,nil,2000,2000,10,RACE_CYBERSE,ATTRIBUTE_DARK) then
	local x=Duel.CreateToken(tp,79029205)
	Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEUP)
end
end
function c79029203.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0)
end
function c79029203.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,79029204,nil,nil,2000,2000,10,RACE_CYBERSE,ATTRIBUTE_DARK) then
	local x=Duel.CreateToken(tp,79029204)
	Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEUP)
	end
end
end


