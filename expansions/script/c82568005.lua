--逆方舟骑士·冬痕 霜星
function c82568005.initial_effect(c)
	c:EnableReviveLimit()
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
	--zone 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568005,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82568005+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c82568005.cost2)
	e2:SetTarget(c82568005.target2)
	e2:SetOperation(c82568005.operation2)
	c:RegisterEffect(e2)
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568005,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c82568005.dacon)
	e3:SetTarget(c82568005.datg)
	e3:SetOperation(c82568005.daop)
	c:RegisterEffect(e3)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568005,3))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c82568005.sumcon)
	e4:SetTarget(c82568005.sumtg)
	e4:SetOperation(c82568005.sumop)
	c:RegisterEffect(e4)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
	--add type
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ADD_TYPE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e8)
end
function c82568005.tunerfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end 
function c82568005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568005.cfilter(c)
	return c:IsFaceup() and c:IsCode(82567852)
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
	if Duel.IsExistingMatchingCard(c82568005.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) then
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
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetAttacker():IsCanBeEffectTarget(e)
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82568005.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)~=0 then
		Duel.NegateAttack()
		c:RegisterFlagEffect(82568005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
function c82568005.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82568005)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c82568005.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82568005.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end