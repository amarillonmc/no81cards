--闪耀之红
local m=60001141
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60001129") end) then require("script/c60001129") end
cm.isColorSong=true  --乱色狂歌
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local record=Color_Song.MonsterRecord(c)
	Color_Song.AddCount(c)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>5 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,6)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,6)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,6,REASON_EFFECT)
	Duel.DiscardDeck(tp,6,REASON_EFFECT)
	Color_Song.Zombie_Limit(e,tp)
	Color_Song.UseEffect(e,tp)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	Color_Song.UseEffect(e,tp)
end