--芳青之梦 双生契
function c21113870.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21113870)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c21113870.cost)
	e1:SetTarget(c21113870.tg)
	e1:SetOperation(c21113870.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_GRAVE_ACTION+CATEGORY_TODECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21113871)
	e2:SetCondition(c21113870.con2)
	e2:SetTarget(c21113870.tg2)
	e2:SetOperation(c21113870.op2)
	c:RegisterEffect(e2)	
end
function c21113870.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc914) and c:IsReleasable()
end
function c21113870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113870.q,tp,4,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21113870.q,tp,4,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21113870.w(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function c21113870.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113870.w,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21113870.w,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0x30)	
end
function c21113870.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
	Duel.BreakEffect()
	Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c21113870.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c21113870.e(c)
	return c:IsFaceupEx() and c:IsSetCard(0xc914) and c:IsAbleToDeck()
end
function c21113870.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113870.e,tp,0x30,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c21113870.e,tp,0x30,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0x30)
end
function c21113870.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
	Duel.BreakEffect()
	Duel.Recover(tp,500,REASON_EFFECT)
	end
end