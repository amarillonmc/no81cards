--トロイメア・グリフォン
--Knightmare Gryphon
--Script by nekrozar
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2)
	c:EnableReviveLimit()
	--Return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5043010,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetMutualLinkedGroupCount()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToHand() end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5043010,2))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()
		and not tc:IsLinkState() and re:IsActiveType(TYPE_MONSTER)
end
