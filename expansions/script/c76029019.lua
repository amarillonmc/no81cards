--辉翼天骑 耀阳之崇光
function c76029019.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsType,TYPE_SYNCHRO),aux.Tuner(Card.IsType,TYPE_SYNCHRO),nil,aux.NonTuner(c76029019.mfilter),1,99)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--disable zone 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e2:SetTarget(c76029019.dztg)
	e2:SetOperation(c76029019.dzop)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76029019,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c76029019.discon)
	e2:SetTarget(c76029019.distg)
	e2:SetOperation(c76029019.disop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76029019,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c76029019.dacon)
	e3:SetCost(c76029019.dacost)
	e3:SetOperation(c76029019.daop)
	c:RegisterEffect(e3)
end
c76029019.named_with_Kazimierz=true 
function c76029019.mfilter(c)
	return c.named_with_Kazimierz 
end
function c76029019.dztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local zone=Duel.SelectField(tp,1,0,LOCATION_MZONE,0x600060)
	e:SetLabel(zone)
	Duel.Hint(HINT_ZONE,tp,zone)	
end
function c76029019.tgfil(c,seq)
	return c:IsAbleToRemove() and c:GetSequence()==seq 
end
function c76029019.dzop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=e:GetLabel()
	local seq=math.log(bit.rshift(zone,16),2)
	local zone=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,seq)
	local g=Duel.GetMatchingGroup(c76029019.tgfil,tp,0,LOCATION_MZONE,0,seq) 
	if g:GetCount()>0 then 
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)
end
function c76029019.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c76029019.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c76029019.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c76029019.dacon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil 
end
function c76029019.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(76029019)==0 end
	c:RegisterFlagEffect(76029019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1) 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(c:GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c:GetBaseAttack())
end
function c76029019.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,x=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,x,REASON_EFFECT)
end






