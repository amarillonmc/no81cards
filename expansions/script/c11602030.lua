--海爬兽联盟

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
    --AtoHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.e3con)
	c:RegisterEffect(e3)
end

--e1
--AtoHand

function s.e1tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand()
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2))) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.e1tohfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end

--e2

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
    local tc=re:GetHandler()
	return rp==tp and tc:IsSetCard(zd) and tc:IsType(TYPE_MONSTER)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--e3

function s.e3confilter(c,tp)
    return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsControler(tp)
end

function s.e3con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.e3confilter,1,nil,tp)
end