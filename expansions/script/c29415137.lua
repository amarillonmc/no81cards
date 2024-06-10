--隐匿之徒全界侵染
local s,id,o=GetID()
function c29415137.initial_effect(c)
	--sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(29415126)  
	e0:SetRange(LOCATION_DECK)  
	e0:SetOperation(s.spop) 
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--special
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x980,TYPE_NORMAL+TYPE_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end
end
--activate
function s.hand(c)
    return c:IsSetCard(0x980) and c:IsAbleToHand()
end
function s.normal(c)
    return c:IsSetCard(0x980) and c:IsSummonable(true,nil)
end
function s.deck(c)
	return c:IsSetCard(0x980) and c:IsLocation(LOCATION_DECK)
end
function s.filter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT) and (c:IsLocation(LOCATION_HAND)and Duel.IsExistingMatchingCard(s.hand,tp,LOCATION_DECK,0,1,nil))
	or (c:IsLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(s.normal,tp,LOCATION_HAND,0,1,nil))
	or (c:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(s.hand,tp,LOCATION_GRAVE,0,1,c))
	or (c==Duel.GetFieldCard(tp,LOCATION_DECK,0) and Duel.IsExistingMatchingCard(s.deck,tp,LOCATION_DECK,0,1,nil))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),tp) end
end 
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:Select(tp,1,1,nil):GetFirst()
	local loc=tg:GetLocation()
	if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		if loc==LOCATION_HAND then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,s.hand,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ag)
		elseif loc==LOCATION_MZONE or loc==LOCATION_SZONE then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local ag=Duel.SelectMatchingCard(tp,s.normal,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Summon(tp,ag:GetFirst(),true,nil)
		elseif loc==LOCATION_GRAVE then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,s.hand,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ag)
		elseif loc==LOCATION_DECK then
			if not Duel.IsExistingMatchingCard(s.deck,tp,LOCATION_DECK,0,1,nil) then return end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
			local ag=Duel.SelectMatchingCard(tp,s.deck,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.ConfirmCards(1-tp,ag)
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(ag,1)
		end
	end
end