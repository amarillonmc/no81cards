--兵虫 爆弹圣甲虫

local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end

s.RAHERAKHTY_CODE = 40020713


function s.initial_effect(c)
		aux.AddCodeList(c,40020713)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1, id + 1)
	e3:SetCost(s.setcost)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 2))
	e4:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_MOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

function s.rmtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1 - tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, 0, LOCATION_GRAVE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end

function s.rmop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
	end
end
function s.cfilter2(c)
	return  s.WeaponInsect(c) and c:IsDiscardable()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.cfilter2,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1)
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) 
		and c:IsFaceup() 
		and not c:IsPreviousLocation(LOCATION_SZONE)
end

function s.thfilter(c)
	if not c:IsAbleToHand() then return false end
	
	if c:IsCode(s.RAHERAKHTY_CODE) then return true end
	
	if s.WeaponInsect(c) and c:GetCode() ~= id and (c:GetOriginalType() & TYPE_MONSTER) ~= 0 then 
		return true 
	end
	
	return false
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end
