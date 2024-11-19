--逆方舟骑士·冬痕 霜星
function c82568005.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,c82568005.tunerfilter,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568005,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,82568005+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c82568005.cost)
	e1:SetTarget(c82568005.target)
	e1:SetOperation(c82568005.operation)
	c:RegisterEffect(e1)
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568005,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c82568005.dacon)
	e3:SetTarget(c82568005.datg)
	e3:SetOperation(c82568005.daop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
	--pendulum
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(c82568005.pencon)
	e11:SetTarget(c82568005.pentg)
	e11:SetOperation(c82568005.penop)
	c:RegisterEffect(e11)
	--effect negate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c82568005.encost)
	e7:SetTarget(c82568005.entg)
	e7:SetOperation(c82568005.enop)
	c:RegisterEffect(e7)
	--Revive
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetCode(EVENT_PHASE+PHASE_END)
	e13:SetRange(LOCATION_PZONE)
	e13:SetCountLimit(1,82568105+EFFECT_COUNT_CODE_DUEL)
	e13:SetCondition(c82568005.sumcon)
	e13:SetTarget(c82568005.sumtg)
	e13:SetOperation(c82568005.sumop)
	c:RegisterEffect(e13)
end
c82568005.material_type=TYPE_SYNCHRO
function c82568005.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82568005)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c82568005.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_PZONE)
end
function c82568005.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	if Duel.SpecialSummon(c,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)~=0 then
	local ba=c:GetBaseAttack()
	local bd=c:GetBaseDefense()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(ba+1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetProperty(EFFECT_CANNOT_DISABLE)
		e2:SetValue(bd+1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
end
end
function c82568005.encost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp/2)
	Duel.PayLPCost(tp,lp/2)
	e:GetHandler():RegisterFlagEffect(82568005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c82568005.enfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c82568005.entg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568005.enfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c82568005.enfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c82568005.enop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c82568005.enfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c82568005.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82568005.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) or re:GetHandler():IsType(TYPE_SPELL) or  re:GetHandler():IsType(TYPE_TRAP)
end
function c82568005.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) 
end
function c82568005.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetChainLimit(aux.FALSE)
end
function c82568005.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function c82568005.tunerfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end 
function c82568005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568005.cfilter(c,e)
	return c==e:GetHandler()
end
function c82568005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
   Duel.SetChainLimit(aux.FALSE)
end
function c82568005.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetCondition(c82568005.discon)
	e1:SetOperation(c82568005.disop)
	e1:SetLabel(seq)
	e:GetHandler():RegisterEffect(e1)
	end
end
function c82568005.discon(e)
	if Duel.IsExistingMatchingCard(c82568005.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,e) then
		return true
	end
	e:Reset()
	return false
end
function c82568005.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
function c82568005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct= 0
	if chk==0 then return 
		 Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) + Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0) >ct end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	Duel.SetChainLimit(aux.FALSE)
end
function c82568005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetCondition(c82568005.discon)
	e1:SetOperation(c82568005.disop2)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
end
function c82568005.disop2(e,tp)
	return e:GetLabel()
end
function c82568005.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c82568005.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==Duel.GetAttacker() end
	if chk==0 then return  not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimit(aux.FALSE)
end
function c82568005.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.NegateAttack()
	end
end