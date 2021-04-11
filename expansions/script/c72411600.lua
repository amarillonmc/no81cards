--马纳历亚女王·安
function c72411600.initial_effect(c)
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411600,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,72411600)
	e1:SetTarget(c72411600.thtg)
	e1:SetOperation(c72411600.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
   --def to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72411601)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c72411600.target2)
	e3:SetOperation(c72411600.operation2)
	c:RegisterEffect(e3)
end
function c72411600.filter(c)
	return c:GetOriginalCode()==72411620 and c:IsAbleToHand()
end
function c72411600.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411600.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72411600.thop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72411600.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local sn=Duel.SendtoHand(g,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
			if sn~=0 and n<=20-- and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Debug.Message(2)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,72411601,0,0x4011,4000,4000,1,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(72411600,0))  then
			Duel.DiscardDeck(tp,2,REASON_EFFECT)
			local token=Duel.CreateToken(tp,72411601)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)	
			end
	end 
end
function c72411600.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c72411600.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT,true)
		Duel.Recover(tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	
end