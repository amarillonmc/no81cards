--空想生物 白孔雀
function c33310201.initial_effect(c)
	 --recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33310201,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33310201)
	e1:SetCost(c33310201.cost)
	e1:SetCondition(c33310201.sccon)
	e1:SetTarget(c33310201.target)
	e1:SetOperation(c33310201.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33310202)
	e2:SetCondition(c33310201.thcon)
	e2:SetTarget(c33310201.thtg)
	e2:SetOperation(c33310201.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c33310201.thcon2)
	c:RegisterEffect(e3)
end

function c33310201.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0 and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end

function c33310201.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c33310201.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c33310201.filter(c)
	return c:IsSetCard(0x551) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33310201)
end
function c33310201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310201.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33310201.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33310201.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33310201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33310201,1))
end
function c33310201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c33310201.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x551)
end
function c33310201.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:IsExists(c33310201.thfil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33310201,0)) then
		local sg=g:FilterSelect(p,c33310201.thfil,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
	else
		local mg=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.SendtoDeck(mg,nil,2,REASON_RULE)
	end
	Duel.ShuffleDeck(p)
end