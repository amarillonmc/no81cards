--混沌之圣女
function c11771550.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c11771550.splimit)
	c:RegisterEffect(e1)
    -- 特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771550,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11771550)
	e2:SetCondition(c11771550.con1)
	e2:SetTarget(c11771550.tg1)
	e2:SetOperation(c11771550.op1)
	c:RegisterEffect(e2)
    -- 盖放
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771550,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,11771551)
	e3:SetTarget(c11771550.tg2)
	e3:SetOperation(c11771550.op2)
	c:RegisterEffect(e3)
    -- 回手特召
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11771550,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_REMOVE)
    e4:SetCountLimit(1,11771552)
	e4:SetTarget(c11771550.tg3)
	e4:SetOperation(c11771550.op3)
	c:RegisterEffect(e4)
    --
    Duel.AddCustomActivityCounter(11771550,ACTIVITY_SPSUMMON,c11771550.counterfilter)
end
-- 效果外文本
function c11771550.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c11771550.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
		or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
end
-- 1
function c11771550.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c11771550.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and #g==Duel.GetMatchingGroupCount(c11771550.filter1,tp,LOCATION_MZONE,0,nil)
end
function c11771550.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11771550.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c11771550.filter2(c,tp)
	return c:IsCode(99266988) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_REMOVED) or (c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(EFFECT_REVERSE_CHECKER)))
end
function c11771550.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11771550.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11771550.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11771550.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			if Duel.SelectYesNo(tp,aux.Stringid(11771550,4)) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetValue(ATTRIBUTE_DARK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
	end
end
-- 3
function c11771550.filter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function c11771550.filter4(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE))
end
function c11771550.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if c:IsLocation(LOCATION_REMOVED) and c:IsAbleToHand() then
		local g1=Duel.GetMatchingGroup(c11771550.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(c11771550.filter4,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		if #g1>0 and #g2>0 then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
		end
	end
end
function c11771550.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		local g1=Duel.GetMatchingGroup(c11771550.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(c11771550.filter4,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
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
