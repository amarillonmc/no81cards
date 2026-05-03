--科蒂赛之虫惑魔
function c87530035.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87530035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,87530035)
	e1:SetCost(c87530035.spcost)
	e1:SetTarget(c87530035.sptg)
	e1:SetOperation(c87530035.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87530035,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,87531035)
	e2:SetTarget(c87530035.sertg)
	e2:SetOperation(c87530035.serop)
	c:RegisterEffect(e2)
	 --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c87530035.efilter)
	c:RegisterEffect(e3)
end

function c87530035.costfilter(c)
	return ((c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER)) or (c:IsRace(RACE_INSECT) and c:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_TRAP))) and not c:IsPublic()
end
function c87530035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87530035.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c87530035.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c87530035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,87530040,0x108a,TYPES_TOKEN_MONSTER,0,0,4,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c87530035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,87530040,0x108a,TYPES_TOKEN_MONSTER,0,0,4,RACE_PLANT,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,87530040)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c87530035.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c87530035.splimit(e,c)
	return not (c:IsRace(RACE_PLANT) or c:IsRace(RACE_INSECT)) 
		and c:IsLocation(LOCATION_EXTRA)
end

function c87530035.sfilter(c,tp)
	return c:IsType(TYPE_MONSTER) 
	and (c:IsRace(RACE_INSECT) or c:IsRace(RACE_PLANT)) 
	and Duel.IsExistingMatchingCard(c87530035.sfilter2,tp,LOCATION_DECK,0,1,nil,c)
	and c:IsAbleToDeck()
end
function c87530035.sfilter2(c,sc)
	return c:IsType(TYPE_MONSTER) 
	and (c:IsRace(RACE_INSECT) or c:IsRace(RACE_PLANT)) and
	c:GetLevel() == sc:GetLevel() and
	c:GetAttribute() == sc:GetAttribute()  and 
	c:GetRace() ~= sc:GetRace()
	and c:IsAbleToHand()
end

function c87530035.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c87530035.sfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c87530035.sfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c87530035.trapfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end
function c87530035.serop(e,tp,eg,ep,ev,re,r,rp)
	local sc = e:GetLabelObject()
	Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87530035.sfilter2,tp,LOCATION_DECK,0,1,1,nil,sc)
	if g:GetCount()~=0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if g:GetFirst():IsSetCard(0x108a) and Duel.SelectYesNo(tp,aux.Stringid(87530035,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c87530035.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()~=0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
end

function c87530035.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and c :IsSetCard(0x4c,0x89)
end