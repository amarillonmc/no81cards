--蝶梦-「绽」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401002.initial_effect(c)
	yume.AddButterflySpell(c,71401002)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71501002)
	e2:SetCondition(c71401002.con2)
	e2:SetCost(c71401002.cost2)
	--e2:SetTarget(c71401002.tg2)
	e2:SetOperation(c71401002.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401002.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function c71401002.filter2(c,tp,check)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsAbleToHand() or check and not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function c71401002.filter2a(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
--[[
function c71401002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c71401002.filter2a,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	end
	return true
end
--]]
function c71401002.filter2b(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71401002.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c71401002.filter2b,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0
		or Duel.Draw(tp,1,REASON_EFFECT)==0 then
		return
	end
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c71401002.filter2a,tp,LOCATION_ONFIELD,0,1,c) then
		return
	end
	local check=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local g=Duel.GetMatchingGroup(c71401002.filter2,tp,LOCATION_DECK,0,nil,tp,check)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401002,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil)
		local b1=tc:IsAbleToHand()
		local b2=check and not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(71401001,5))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end