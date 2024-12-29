--海爬兽宝宝 小鱼龙

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--DeckGraveToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EFFECT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--RemoveOpHands
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

end

--e1
--DeckGraveToHand

function s.e1tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand() and c:IsCode(11602026,11602028)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetTarget(s.e1lmtg)
	c:RegisterEffect(e1)
	
    if not (Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e1tohfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e1tohfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end

function s.e1lmtg(c,e)
    return not c:IsSetCard(zd) and c:IsLocation(LOCATION_EXTRA)
end

--e2
--RemoveOpHands

function s.e2confilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,1,nil) 
	and r==REASON_EFFECT and rp==1-tp
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.e2rmfilter(c,tp)
    return c:IsAbleToRemove() and c:IsControler(1-tp) and c:IsLocation(LOCATION_HAND)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(s.e2rmfilter,1,nil,tp) end
    local rg=eg:Filter(s.e2rmfilter,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,LOCATION_HAND)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
    local rg=eg:Filter(s.e2rmfilter,nil,tp)
    local sg=rg:Filter(Card.IsRelateToEffect,nil,e)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
