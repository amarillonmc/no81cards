--暴虐帝皇 瀚宇星皇
function c16362021.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c16362021.mfilter,aux.NonTuner(Card.IsSetCard,0xdc0),2)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c16362021.efilter)
	c:RegisterEffect(e1)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c16362021.eqcon)
	e3:SetCost(c16362021.eqcost)
	e3:SetTarget(c16362021.eqtg)
	e3:SetOperation(c16362021.eqop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,16362021)
	e4:SetCondition(c16362021.discon)
	e4:SetCost(c16362021.discost)
	e4:SetTarget(c16362021.distg)
	e4:SetOperation(c16362021.disop)
	c:RegisterEffect(e4)
	--[[con
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16362021)
	e3:SetCondition(c16362021.condition)
	e3:SetTarget(c16362021.target)
	e3:SetOperation(c16362021.operation)
	c:RegisterEffect(e3)]]
end
function c16362021.mfilter(c)
	return c:IsSetCard(0xdc0) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c16362021.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xdc0)
end
function c16362021.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c16362021.eqfilter(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c16362021.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16362021.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,c,tp)
	local sct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ct=math.min(g:GetClassCount(Card.GetCode),sct)
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,ct,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c16362021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16362021.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16362021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ft<ct or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16362021.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if not sg then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=sg:GetNext()
	end
	Duel.EquipComplete()
end
function c16362021.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c16362021.cfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c16362021.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetEquipGroup()
	if chk==0 then return cg:IsExists(c16362021.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=cg:FilterSelect(tp,c16362021.cfilter,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16362021.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16362021,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16362021.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--[[function c16362021.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)~=0
end
function c16362021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,16362021)==0 end
end
function c16362021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(re:GetActivateLocation())
	e1:SetValue(c16362021.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,16362021,RESET_PHASE+PHASE_END,0,0)
end
function c16362021.aclimit(e,re,tp)
	local loc=e:GetLabel()
	if loc==LOCATION_SZONE or loc==LOCATION_MZONE then loc=LOCATION_ONFIELD end
	return bit.band(re:GetActivateLocation(),loc)==0
end]]