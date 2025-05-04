--无边幻梦 淫梦的普路梅西亚
function c75075605.initial_effect(c)
	-- 特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075605,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,75075605)
	e1:SetCondition(c75075605.con1)
	e1:SetTarget(c75075605.tg1)
	e1:SetOperation(c75075605.op1)
	c:RegisterEffect(e1)
    -- 发动场地
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(75075605,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075604)
	e2:SetTarget(c75075605.tg2)
	e2:SetOperation(c75075605.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c75075605.con2)
	c:RegisterEffect(e3)
end
-- 1
function c75075605.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c75075605.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75075605.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(75075605,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
-- 2
function c75075605.con2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c75075605.filter22(c,tp)
	return c:IsSetCard(0x5754) and c:IsType(TYPE_FIELD)
		and c:GetActivateEffect()
		and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c75075605.filter2(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75075605.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) and chkc:IsAbleToHand() end
    if chk==0 then
        return Duel.IsExistingTarget(c75075605.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingMatchingCard(c75075605.filter22,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c75075605.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75075605.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75075605.filter22),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		local sc=g:GetFirst()
		if sc then
			local field=sc:IsType(TYPE_FIELD)
			if field then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
				end
				Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local te=sc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local cost=te:GetCost()
			if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
		end
	end
end
