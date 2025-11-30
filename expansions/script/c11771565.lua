--混沌之司教
function c11771565.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11771565.splimit)
	c:RegisterEffect(e1)
	-- 特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771565,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,11771565)
	e2:SetCost(c11771565.cost1)
	e2:SetTarget(c11771565.tg1)
	e2:SetOperation(c11771565.op1)
	c:RegisterEffect(e2)
	-- 遗言特召
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771565,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,11771566)
	e3:SetCondition(c11771565.con2)
	e3:SetTarget(c11771565.tg2)
	e3:SetOperation(c11771565.op2)
	c:RegisterEffect(e3)
    -- 回手特召
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11771565,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_REMOVE)
    e4:SetCountLimit(1,11771567)
	e4:SetTarget(c11771565.tg3)
	e4:SetOperation(c11771565.op3)
	c:RegisterEffect(e4)
    --
    Duel.AddCustomActivityCounter(11771565,ACTIVITY_SPSUMMON,c11771565.counterfilter)
end
-- 效果外文本
function c11771565.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c11771565.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
		or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
end
-- 1
function c11771565.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
		and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function c11771565.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11771565.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11771565.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11771565.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11771565.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c11771565.con2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c11771565.spfilter(c,e,tp)
	return c:IsSetCard(0xcf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsSummonableCard()
end
function c11771565.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11771565.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11771565.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11771565.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 3
function c11771565.filter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function c11771565.filter4(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function c11771565.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if c:IsLocation(LOCATION_REMOVED) and c:IsAbleToHand() then
		local g1=Duel.GetMatchingGroup(c11771565.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(c11771565.filter4,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		if #g1>0 and #g2>0 then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
		end
	end
end
function c11771565.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		local g1=Duel.GetMatchingGroup(c11771565.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(c11771565.filter4,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(11771550,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==2 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
