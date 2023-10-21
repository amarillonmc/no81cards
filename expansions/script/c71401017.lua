--花幻-「簇」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401017.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c71401017.defval)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401001,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401017)
	e2:SetCost(c71401017.cost2)
	e2:SetTarget(yume.ButterflyPlaceTg)
	e2:SetOperation(c71401017.op2)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401017,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71501017)
	e3:SetCondition(c71401017.con3)
	e3:SetCost(c71401017.cost3)
	e3:SetTarget(c71401017.tg3)
	e3:SetOperation(c71401017.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
function c71401017.deffilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup()
end
function c71401017.defval(e,c)
	return Duel.GetMatchingGroupCount(c71401017.deffilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-200
end
function c71401017.filterc2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c71401017.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401017.filterc2,tp,LOCATION_EXTRA,0,1,nil,tp) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401017.filterc2,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401017.filter2(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401017.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71401017.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401017,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=mg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c71401017.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401017.filterc3(c,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c71401017.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv)
end

function c71401017.filter3(c,lv)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and not (c:IsType(TYPE_TUNER) and c:IsLevel(lv))
end
function c71401017.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401017.filterc3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mc=Duel.SelectMatchingCard(tp,c71401017.filterc3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.Remove(mc,POS_FACEUP,REASON_COST)
	e:SetLabel(mc:GetLevel())
	yume.RegButterflyCostLimit(e,tp)
end
function c71401017.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71401017.filter3(chkc,e:GetLabel()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71401017.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetLabel())
end
function c71401017.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
	end
end