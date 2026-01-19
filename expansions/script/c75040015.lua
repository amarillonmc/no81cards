--器者百式-威戟崩峦
function c75040015.initial_effect(c)
	aux.AddCodeList(c,75040001)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75040015,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c75040015.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75040015.target)
	e1:SetOperation(c75040015.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75040015.thtg)
	e2:SetOperation(c75040015.thop)
	c:RegisterEffect(e2)
end
function c75040015.hcfilter(c)
	return c:IsCode(75040001) and c:IsFaceup()
end
function c75040015.handcon(e)
	return Duel.IsExistingMatchingCard(c75040015.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c75040015.tfilter(c,tp)
	return c:IsRace(RACE_WYRM) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c75040015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75040015.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c75040015.tfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,75040022,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_WYRM,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c75040015.tfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c75040015.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c75040013.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or Duel.Release(tc,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,75040022,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_WYRM,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,75040022)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c75040015.thfilter(c,chk)
	return aux.IsCodeListed(c,75040001) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c75040015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75040015.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75040015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c75040015.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) then return end
end
