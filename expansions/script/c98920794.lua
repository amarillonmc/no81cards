--天位伪装骑士
function c98920794.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c98920794.ffilter,2,true)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920794,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920794)
	e1:SetCondition(c98920794.thcon)
	e1:SetTarget(c98920794.thtg)
	e1:SetOperation(c98920794.thop)
	c:RegisterEffect(e1)
	--Activate Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c98920794.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920794.atkcon)
	e2:SetValue(1300)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920794,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,98930794)
	e2:SetTarget(c98920794.drtg)
	e2:SetOperation(c98920794.drop)
	c:RegisterEffect(e2)
end
function c98920794.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_WARRIOR) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c98920794.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c98920794.thfilter(c)
	return aux.IsCodeListed(c,25652259) and aux.IsCodeListed(c,64788463) and aux.IsCodeListed(c,90876561) and c:IsAbleToHand()
end
function c98920794.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920794.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920794.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920794.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920794.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c98920794.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c98920794.tdfilter(c)
	return c:IsCode(25652259,64788463,90876561) and c:IsAbleToHand()
end
function c98920794.gcheck(g)
	return g:FilterCount(Card.IsCode,nil,25652259)<=1
		and g:FilterCount(Card.IsCode,nil,64788463)<=1
		and g:FilterCount(Card.IsCode,nil,90876561)<=1
end
function c98920794.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920794.tdfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_HAND)
end
function c98920794.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c98920794.tdfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c98920794.gcheck,false,1,3)
		if sg then
			local ct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if ct>0 then
				Duel.Draw(tp,ct,REASON_EFFECT)
			   	local g=Duel.GetMatchingGroup(c98920794.thdfilter,tp,LOCATION_DECK,0,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920794,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sg=g:Select(tp,1,1,nil)
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				 end
			end
		end
	end
end
function c98920794.thdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(10) and c:IsAbleToHand()
end