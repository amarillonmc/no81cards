--海爬兽宝宝 小海蛇

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--DeckToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EFFECT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--DeckToHandRepDraw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

end

--e1
--DeckToHand

function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function s.e1tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand() and not c:IsCode(id)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(LOCATION_EXTRA,0)
	e1:SetCountLimit(1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
    if not (Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_DECK,0,1,nil)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.e1tohfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end

function s.e1lmtg(c,e)
    return not c:IsSetCard(zd) and c:IsLocation(LOCATION_EXTRA)
end

--e2
--DeckToHandRepDraw

function s.e1confilter(c)
    return c:IsFaceup() and c:IsSetCard(zd) and c:IsType(TYPE_FUSION)
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(s.e2confilter,tp,LOCATION_MZONE,0,4,nil) 
end

function s.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand()
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(s.e2tohfilter,tp,LOCATION_DECK,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_DECK)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not aux.IsPlayerCanNormalDraw(tp) then return end
	aux.GiveUpNormalDraw(e,tp)
	
    if not (Duel.IsExistingMatchingCard(s.e2tohfilter,tp,LOCATION_DECK,0,2,nil)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.e2tohfilter,tp,LOCATION_DECK,0,2,2,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end
