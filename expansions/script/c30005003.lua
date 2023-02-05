--异仪呼
local m=30005003
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,30005000)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.thcon1)
	e4:SetTarget(cm.thtg1)
	e4:SetOperation(cm.thop1)
	c:RegisterEffect(e4)
	--Effect 2  
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.thcon2)
	e5:SetTarget(cm.thtg2)
	e5:SetOperation(cm.thop2)
	c:RegisterEffect(e5)
end
--Filter
function cm.th(c,code)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	if c:IsCode(m) then return false end
	local sh=c:IsCode(code) or aux.IsCodeListed(c,code)
	return sh and c:IsAbleToHand()
end
--Effect 1
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_RITUAL) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,30005030) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,30005030)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end 
--Effect 2
function cm.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsSummonPlayer(tp)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK,0,1,nil,30005000) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.th,tp,LOCATION_DECK,0,1,1,nil,30005000)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end 
