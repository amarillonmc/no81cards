--幻叙·编造的星光
function c10200113.initial_effect(c)
	-- 卡组检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200113,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10200113)
	e1:SetCost(c10200113.cost1)
	e1:SetTarget(c10200113.tg1)
	e1:SetOperation(c10200113.op1)
	c:RegisterEffect(e1)
	-- 冻结
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200113,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200114)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10200113.tg2)
	e2:SetOperation(c10200113.op2)
	c:RegisterEffect(e2)
	-- 遗言特招
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200113,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c10200113.con3)
	e3:SetTarget(c10200113.tg3)
	e3:SetOperation(c10200113.op3)
	c:RegisterEffect(e3)
end
-- 1
function c10200113.filter1(c)
	return c:IsSetCard(0x838) and c:IsDiscardable()
end
function c10200113.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200113.filter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c10200113.filter1,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c10200113.filter11(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200113.filter111(c,e,tp)
	return c:IsSetCard(0x838) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200113.filter1111(c)
	return c:IsFaceup() and c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function c10200113.con1(tp)
	return Duel.IsExistingMatchingCard(c10200113.filter1111,tp,LOCATION_MZONE,0,1,nil)
end
function c10200113.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200113.filter11,tp,LOCATION_DECK,0,1,nil)
		or (c10200113.con1(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10200113.filter111,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10200113.op1(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c10200113.filter11,tp,LOCATION_DECK,0,1,nil)
	local b2=c10200113.con1(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10200113.filter111,tp,LOCATION_DECK,0,1,nil,e,tp)
	if not b1 and not b2 then return end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10200113,3),aux.Stringid(10200113,4))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10200113.filter11,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10200113.filter111,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
-- 2
function c10200113.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c10200113.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10200113.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10200113.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200113.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10200113.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
	end
end
-- 3
function c10200113.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and rp==1-tp
end
function c10200113.filter3(c,e,tp)
	return c:IsCode(10200115) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10200113.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10200113.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10200113.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200113.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
