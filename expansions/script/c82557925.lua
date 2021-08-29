--百兽钢战-牙吠半人马
function c82557925.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),9,4)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557925,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,82557925)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82557925.actcost)
	e2:SetTarget(c82557925.acttarget)
	e2:SetOperation(c82557925.actoperation)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82557825)
	e3:SetCondition(c82557925.descon1)
	e3:SetTarget(c82557925.destg1)
	e3:SetOperation(c82557925.desop1)
	c:RegisterEffect(e3)
end
function c82557925.filter(c)
	return c:IsFaceup() 
end
function c82557925.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetTurnPlayer()~=tp end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82557925.acttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82557925.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82557925.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c82557925.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c82557925.actoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local rc=tc:GetAttribute()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetTargetRange(0,1)
	e6:SetLabel(rc)
	e6:SetValue(c82557925.aclimit)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
end
function c82557925.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsAttribute(e:GetLabel())
end
function c82557925.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsRace(RACE_MACHINE)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end

function c82557925.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82557925.cfilter,1,nil,tp) and eg:GetCount()==1
end
function c82557925.desfilter(c,rc,e)
	return c:IsFaceup() and c:IsAttribute(rc) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c82557925.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=eg:GetFirst():GetAttribute()
	e:SetLabel(rc)
	if chk==0 then return Duel.IsExistingMatchingCard(c82557925.desfilter,tp,0,LOCATION_MZONE,1,nil,rc,e) end
	local g=Duel.GetMatchingGroup(c82557925.desfilter,tp,0,LOCATION_MZONE,nil,rc,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82557925.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabel()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82557925.desfilter,tp,0,LOCATION_MZONE,nil,rc,e)
	Duel.Destroy(g,REASON_EFFECT)
 
end