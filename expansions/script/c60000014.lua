--秘旋谍-废墟少女
function c60000014.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000014,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c60000014.drtg)
	e1:SetOperation(c60000014.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60000014,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c60000014.spcon)
	e3:SetCost(c60000014.spcost)
	e3:SetTarget(c60000014.sptg)
	e3:SetOperation(c60000014.spop)
	c:RegisterEffect(e3)
end
function c60000014.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,1)
end
function c60000014.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local tc=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsSetCard(0xee) then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)~=0 and Duel.SelectYesNo(tp,aux.Stringid(60000014,1)) then
			Duel.ConfirmCards(tp,Duel.GetDecktopGroup(1-tp,1))
		end
		if Duel.GetFlagEffect(tp,60000014)==0 and Duel.IsExistingMatchingCard(c60000014.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60000014,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c60000014.filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
				Duel.RegisterFlagEffect(tp,60000014,RESET_PHASE+PHASE_END,0,1)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c60000014.filter(c)
	return c:IsSetCard(0xee) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsSetCard(0x10ee) and c:IsAbleToHand()
end
function c60000014.cfilter(c)
	return c:IsFaceup() and c:IsCode(41091257)
end
function c60000014.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60000014.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60000014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60000014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60000014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
