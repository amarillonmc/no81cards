--虹龍·墨龙
function c11185275.initial_effect(c)
	aux.AddCodeList(c,0x452)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.TargetBoolFunction(Card.IsSetCard,0x453),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c11185275.synlimit)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11185275)
	e2:SetCondition(c11185275.discon)
	e2:SetCost(c11185275.discost)
	e2:SetTarget(c11185275.distg)
	e2:SetOperation(c11185275.disop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11185275+1)
	e3:SetCondition(c11185275.lzcon)
	e3:SetTarget(c11185275.lztg)
	e3:SetOperation(c11185275.lzop)
	c:RegisterEffect(e3)
end
c11185275.material_type=TYPE_SYNCHRO
function c11185275.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and not se
end
function c11185275.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c11185275.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function c11185275.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11185275.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c11185275.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c11185275.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0xffe0)
	Duel.SetTargetParam(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c11185275.lzop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end