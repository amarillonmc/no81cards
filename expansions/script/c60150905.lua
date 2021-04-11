--幻想曲T致命旋律 整备
function c60150905.initial_effect(c)
Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(c60150905.sscon)
	e1:SetTarget(c60150905.sstg)
	e1:SetOperation(c60150905.ssop)
	c:RegisterEffect(e1)
	--Effect Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	c:RegisterEffect(e2)
end
function c60150905.thfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c60150905.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60150905.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60150905.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60150992,0,0x4011,1500,2000,5,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60150905.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60150992,0,0x4011,1500,2000,5,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,60150992)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60150905,1))
		e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCondition(c60150905.spcon)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
		e1:SetTarget(c60150905.sptg)
		e1:SetOperation(c60150905.spop)
		e1:SetReset(RESET_EVENT+0x1de0000)
		c:RegisterEffect(e1)
	end
end
function c60150905.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c60150905.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60150905.filter(c)
	return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c60150905.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.Destroy(c,REASON_EFFECT)==0 then return end
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			if g:GetCount()==0 then return end
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			if Duel.Draw(tp,g:GetCount()-1,REASON_EFFECT) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(1-tp,c60150905.filter,1-tp,LOCATION_HAND,0,1,63,nil)
				if g:GetCount()>0 then
					Duel.ConfirmCards(tp,g)
					local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
					Duel.ShuffleDeck(1-tp)
					Duel.BreakEffect()
					Duel.Draw(1-tp,ct+1,REASON_EFFECT)
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
				end
			end
		else
			Duel.Destroy(c,REASON_RULE)
		end
	end
end
function c60150905.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK))
end