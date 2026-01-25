--SPiNEL
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
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY+TYPE_CONTINUOUS+TYPE_FIELD+TYPE_RITUAL+TYPE_EQUIP) and c:IsAbleToGraveAsCost()
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
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.Readjust()
end
function s.cnttarget(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(s.con)
    e1:SetTarget(s.cnttg)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function s.cnttg(e,c)
	return c:GetOriginalType()&TYPE_LINK~=0 and c:GetOriginalRace()&RACE_SPELLCASTER~=0
end
function s.tohand(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.con)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.lffilter(c,tp,e)
    return c:GetOriginalType()&TYPE_LINK~=0 and c:GetOriginalRace()&RACE_SPELLCASTER~=0 and c:IsAbleToExtra()
    and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeEffectTarget(e)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.thfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY+TYPE_CONTINUOUS+TYPE_FIELD+TYPE_RITUAL+TYPE_EQUIP) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsType,3,nil,TYPE_SPELL) then
            if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
                g:Sub(sg)
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
                Duel.ShuffleHand(tp)
            end
            Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
        else
            Duel.ShuffleDeck(tp)
		end
	end
end
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	s.sprule(c)
    s.cnttarget(c)
    s.tohand(c)
end
