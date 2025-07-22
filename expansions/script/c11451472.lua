--蚁蚀的溶穴
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:GetOriginalType()&TYPE_MONSTER>0 and ((c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_INSECT) and c:IsType(TYPE_EFFECT)) or (not c:IsLocation(LOCATION_MZONE) and c:GetOriginalRace()&RACE_INSECT>0 and c:GetOriginalType()&TYPE_EFFECT>0)) and c:IsFaceup()
end
function cm.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttackAbove(1000) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMING_MAIN_END)
		e1:SetCondition(cm.spcon1)
		e1:SetTarget(cm.sptg1)
		e1:SetOperation(cm.spop1)
		e1:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetHintTiming(TIMING_ATTACK)
		e2:SetCost(cm.mvcost)
		e2:SetTarget(cm.mvtg)
		e2:SetOperation(cm.mvop)
		e2:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e2,true)
		if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_REMOVE_TYPE)
			e4:SetValue(TYPE_NORMAL)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
end
function cm.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-1000)
	tc:RegisterEffect(e1,true)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsRelateToEffect(e) and ft>0 then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()&0x20004==0x20004
end
function cm.getsetcard(c)
	for i=0,0xfff do
		if c:IsOriginalSetCard(i) then
			for j=0xf,1,-1 do
				if c:IsOriginalSetCard(i+0x1000*j) then return i+0x1000*j end
			end
			return i
		end
	end
	return nil
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffectLabel(m)==0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end--Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),cm.getsetcard(c),c:GetOriginalType(),math.max(0,c:GetTextAttack()),math.max(0,c:GetTextDefense()),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute()) end
	c:SetFlagEffectLabel(m,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsAbleToHand() and not c:IsSummonableCard()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) or not tc:IsControler(tp) then return end
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSpecialSummonable(0) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummonRule(tp,tc,0)
		end
	end
end