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
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY+TYPE_CONTINUOUS+TYPE_FIELD+TYPE_RITUAL+TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
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
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.Readjust()
end
function s.disable(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.con)
    e1:SetTarget(s.distg)
    e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function s.distg(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end
function s.toextra(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.con)
    e1:SetTarget(s.tetg)
    e1:SetOperation(s.teop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e2)
end
function s.lffilter(c,tp,e)
    return c:GetOriginalType()&TYPE_LINK~=0 and c:GetOriginalRace()&RACE_SPELLCASTER~=0 and c:IsAbleToExtra()
    and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeEffectTarget(e)
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and s.lffilter(chkc,tp,e) end
    if chk==0 then return eg:IsExists(s.lffilter,1,nil,tp,e) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eg:FilterSelect(tp,s.lffilter,1,1,nil,tp,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	s.sprule(c)
    s.disable(c)
    s.toextra(c)
end
