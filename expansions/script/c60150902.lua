--幻想曲T致命旋律 降落
function c60150902.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	--e2:SetCondition(c60150902.sscon)
	e2:SetTarget(c60150902.sstg)
	e2:SetOperation(c60150902.ssop)
	c:RegisterEffect(e2)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c60150902.valcon)
	c:RegisterEffect(e1)
end
function c60150902.thfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c60150902.sscon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60150902.thfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60150902.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60150989,0,0x4011,1200,2000,2,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60150902.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60150989,0,0x4011,1200,2000,2,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,60150989)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60150902,1))
		e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCondition(c60150902.spcon)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
		e1:SetTarget(c60150902.sptg)
		e1:SetOperation(c60150902.spop)
		e1:SetReset(RESET_EVENT+0x1de0000)
		c:RegisterEffect(e1)
	end
end
function c60150902.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c60150902.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60150902.filter(c)
	return c:IsFaceup()
end
function c60150902.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.Destroy(c,REASON_EFFECT)==0 then return end
			local g=Duel.GetMatchingGroup(c60150902.filter,1-tp,0,LOCATION_MZONE,e:GetHandler())
			if g:GetCount()>0 then
				local tc=nil
				local tg=g:GetMaxGroup(Card.GetAttack)
				if tg:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
					local sg=tg:Select(1-tp,1,1,nil)
					Duel.HintSelection(sg)
					tc=sg:GetFirst()
				else
					tc=tg:GetFirst()
				end
				local atk=tc:GetAttack()
				if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
					Duel.Damage(tp,atk,REASON_EFFECT)
					Duel.BreakEffect()
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
				end
			end
		else
			Duel.Destroy(c,REASON_RULE)
		end
	end
end
function c60150902.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c60150902.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK))
end