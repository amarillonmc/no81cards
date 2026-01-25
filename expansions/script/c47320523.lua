--RHODONiTE
local s,id=GetID()
function s.sprule(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(s.tfcon)
	e2:SetOperation(s.tfop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS+TYPE_COUNTER) and c:IsAbleToGraveAsCost()
end
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()~=tp or not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then return false end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
    if not Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,2,nil) then return false end
    local c=e:GetHandler()
	return c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
    e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.Readjust()
end
function s.immune(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.con)
    e1:SetTarget(s.immtg)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetValue(s.immval)
	c:RegisterEffect(e1)
    if not s.global_check then
		s.global_check=true
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAINING)
        e2:SetRange(LOCATION_SZONE)
        e2:SetOperation(s.opera)
        Duel.RegisterEffect(e2,0)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.immtg(e,c)
	return c:GetOriginalType()&TYPE_LINK~=0 and c:GetOriginalRace()&RACE_SPELLCASTER~=0 and c:GetFlagEffect(47320523)==0
end
function s.immval(e,te)
	return te:IsActiveType(TYPE_MONSTER+TYPE_SPELL) and te:IsActivated() and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.opera(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsOnField() and rc:IsFaceup() and rc:GetOriginalType()&TYPE_LINK~=0 and rc:GetOriginalRace()&RACE_SPELLCASTER~=0 then
        rc:RegisterFlagEffect(47320523,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function s.destory(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.descon)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return s.con(e,tp,eg,ep,ev,re,r,rp) and loc&LOCATION_ONFIELD==0 and re:IsActiveType(TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	s.sprule(c)
    s.immune(c)
    s.tohand(c)
end
