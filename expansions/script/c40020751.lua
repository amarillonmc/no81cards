--皇兽·Z·秃鹫
local s,id=GetID()
s.named_with_EmperorBeast=1

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020683)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_THUNDER),2,2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon1)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon2)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end

function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.get_ban_codes(tp)
	local ban_codes = {}
	
	local fg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_ONFIELD, 0, nil)
	for tc in aux.Next(fg) do
		ban_codes[tc:GetCode()] = true
	end
	
	local gg = Duel.GetMatchingGroup(nil, tp, LOCATION_GRAVE, 0, nil)
	for tc in aux.Next(gg) do
		ban_codes[tc:GetCode()] = true
	end
	
	return ban_codes
end

function s.thfilter1(c, ban_codes)
	return s.EmperorBeast(c) and c:IsAbleToHand() and not ban_codes[c:GetCode()]
end

function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ban_codes = s.get_ban_codes(tp)
		return Duel.IsExistingMatchingCard(s.thfilter1, tp, LOCATION_DECK, 0, 1, nil, ban_codes)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local ban_codes = s.get_ban_codes(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, s.thfilter1, tp, LOCATION_DECK, 0, 1, 1, nil, ban_codes)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.cfilter(c,ec,tp)
	if not c:IsSummonType(SUMMON_TYPE_RITUAL) then return false end
	local zone = ec:GetLinkedZone(tp)
	local c_seq = c:GetSequence()
	return (zone & (1 << c_seq)) ~= 0
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not c:IsLocation(LOCATION_MZONE) then return false end
	return eg:IsExists(s.cfilter, 1, nil, c, tp)
end

function s.thfilter2(c)
	return s.EmperorBeast(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter2, tp, LOCATION_GRAVE, 0, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp, s.thfilter2, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
