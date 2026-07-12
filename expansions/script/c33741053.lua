--近心芽姬·风冠 卡菲
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	GearGal.AddNearGalEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.evfilter(c) return (c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()) or (c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsSummonType(SUMMON_TYPE_SPECIAL)) end
function s.condition(e,tp,eg) return eg:IsExists(s.evfilter,1,nil) end
function s.filter(c) return c:IsSetCard(0x1449) and c:IsAbleToDeck() end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,2,2,nil) Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0) Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==2 then Duel.ShuffleDeck(tp) Duel.Draw(tp,1,REASON_EFFECT) end
end
