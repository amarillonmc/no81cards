-- 深渊灵海
function c10200018.initial_effect(c)
	-- 发动限制
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10200018+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	-- 卡组检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200018,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,10200018)
	e2:SetTarget(c10200018.tg1)
	e2:SetOperation(c10200018.op1)
	c:RegisterEffect(e2)
	-- 回复生命
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c10200018.con2)
	e3:SetOperation(c10200018.op2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
-- 1
function c10200018.filter1(c)
	return c:IsSetCard(0xe21) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200018.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200018.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200018.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200018.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 2
function c10200018.filter2(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xe21)
end
function c10200018.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200018.filter2,1,nil,tp)
end
function c10200018.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Recover(tp,500,REASON_EFFECT)
end