--EPiDOTE
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
function s.rmfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS+TYPE_COUNTER) and c:IsAbleToRemoveAsCost()
end
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()~=tp or not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then return false end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
    if not Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,2,nil) then return false end
    local c=e:GetHandler()
	return c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
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
function s.recover(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SSET)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.con)
    e1:SetOperation(s.reop)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and rp==tp
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,400,REASON_EFFECT)
end
function s.set(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.setcon)
    e1:SetTarget(s.settg)
    e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,e,tp)
    return c:IsPreviousControler(tp)
    and (c:IsType(TYPE_TRAP) and c:IsPreviousLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanSSet(tp,c))
    or (c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_SZONE) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS and eg:IsExists(s.tgfilter,1,nil,e,tp)
end
function s.setfilter(c,tp,e)
    return c:GetOriginalType()&TYPE_LINK~=0 and c:GetOriginalRace()&RACE_SPELLCASTER~=0 and c:IsAbleToExtra()
    and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeEffectTarget(e)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and s.tgfilter(chkc,e,tp) end
    if chk==0 then return eg:IsExists(s.tgfilter,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=eg:FilterSelect(tp,s.tgfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_MONSTER) then
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
        if tc:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0 then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
        elseif tc:IsType(TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
            Duel.SSet(tp,tc)
        end
	end
end
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	s.sprule(c)
    s.recover(c)
    s.set(c)
end
