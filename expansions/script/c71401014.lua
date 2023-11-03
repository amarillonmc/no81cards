--花构-「离」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401014.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c71401014.mfilter,nil,2,2)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c71401014.chainop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401001,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401014)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(yume.ButterflyPlaceTg)
	e2:SetOperation(c71401014.op2)
	c:RegisterEffect(e2)
	--remove monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401014,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71501014)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c71401014.con3)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetTarget(c71401014.tg3)
	e3:SetOperation(c71401014.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401014.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsRank(4)
end
function c71401014.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetOriginalType()&TYPE_MONSTER~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActivateLocation()==LOCATION_SZONE and c:IsFaceup() then
		Duel.SetChainLimit(c71401014.chainlm)
	end
end
function c71401014.chainlm(re,rp,tp)
	return tp==rp or not re:GetHandler():IsType(TYPE_MONSTER)
end
function c71401014.filter2(c,e,tp,ac)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN) and not c:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,0,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,Group.FromCards(c,ac),tp,POS_FACEDOWN)
end
function c71401014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local ct=c:GetOverlayCount()
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local mg=Duel.GetMatchingGroup(c71401014.filter2,tp,LOCATION_ONFIELD,0,c,e,tp,c)
			if ct>0 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401014,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg1=mg:Select(tp,1,1,c)
				local rc1=rg1:GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),0,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,Group.FromCards(rc1,c),tp,POS_FACEDOWN)
				rg2:AddCard(rc1)
				Duel.Remove(rg2,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function c71401014.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c71401014.filter3(c,tp,ac)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,Group.FromCards(c,ac),tp,POS_FACEDOWN)
end
function c71401014.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return Duel.IsExistingMatchingCard(c71401014.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c71401014.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401014.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,Group.FromCards(tc,c),tp,POS_FACEDOWN)
		rg:AddCard(tc)
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end