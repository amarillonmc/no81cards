--妖蛇界 蛇型视界
local s,id=GetID()
function s.DarkSnake(c)
	local m = _G["c"..c:GetCode()]
	if m and m.named_with_DarkSnake then return true end
	if c:GetCode() == 40020764 and c:IsLocation(LOCATION_PZONE) then return true end
	return false
end
s.named_with_DarkSnake=1

function s.initial_effect(c)
	aux.AddCodeList(c,40020764)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

function s.thfilter_pre(c, code)
	return s.DarkSnake(c) and c:GetCode() ~= code and c:IsAbleToHand()
end
function s.tgfilter_check(c, tp)
	if not (c:IsFaceup() and s.DarkSnake(c)) then return false end
	local code = c:GetCode()
	return Duel.IsExistingMatchingCard(s.thfilter_pre, tp, LOCATION_DECK, 0, 1, nil, code)
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc~=c and s.tgfilter_check(chkc, tp) end
	if chk==0 then
		return Duel.IsExistingTarget(s.tgfilter_check, tp, LOCATION_ONFIELD, 0, 1, c, tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp, s.tgfilter_check, tp, LOCATION_ONFIELD, 0, 1, 1, c, tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thfilter_op(c, tc)
	return s.DarkSnake(c) and c:GetCode() ~= tc:GetCode() and c:IsAbleToHand()
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, s.thfilter_op, tp, LOCATION_DECK, 0, 1, 1, nil, tc)
	if #g>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(40020764)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tg2filter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(s.tg2filter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tg2filter,tp,LOCATION_GRAVE,0,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end

function s.tg2filter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and s.DarkSnake(c) and c~=ec
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end