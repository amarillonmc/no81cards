--传承之物-先导者
function c10700283.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700283,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10700283)
	e1:SetCost(c10700283.thcost)
	e1:SetTarget(c10700283.thtg)
	e1:SetOperation(c10700283.thop)
	c:RegisterEffect(e1)  
	--announce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700283,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_ANNOUNCE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700292)
	e3:SetCondition(c10700283.ancon)
	e3:SetTarget(c10700283.antg)
	e3:SetOperation(c10700283.anop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10700292)
	e4:SetCondition(c10700283.ancon2)
	e4:SetTarget(c10700283.antg)
	e4:SetOperation(c10700283.anop)
	c:RegisterEffect(e4) 
end
function c10700283.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10700283.thfilter(c)
	return c:IsSetCard(0x7c3) and not c:IsCode(10700283) and c:IsAbleToHand()
end
function c10700283.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700283.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700283.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700283.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700283.ancon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and not Duel.IsPlayerAffectedByEffect(tp,10700291)
end
function c10700283.ancon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700291)
end
function c10700283.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c10700283.anop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) then
			if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(10700283,2)) then
			   Duel.SendtoHand(tc,nil,REASON_EFFECT)
			   Duel.ConfirmCards(1-tp,tc)
			elseif tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			   Duel.DisableShuffleCheck()
			   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			elseif tc:IsType(TYPE_SPELL) and tc:IsAbleToGrave() then
			   Duel.DisableShuffleCheck()
			   Duel.SendtoGrave(tc,REASON_EFFECT)
			   local ae=tc:GetActivateEffect()
			   if tc:GetLocation()==LOCATION_GRAVE and ae then
			   local e1=Effect.CreateEffect(tc)
			   e1:SetDescription(ae:GetDescription())
			   e1:SetType(EFFECT_TYPE_QUICK_O)
			   e1:SetCode(EVENT_FREE_CHAIN)
			   e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			   e1:SetCountLimit(1)
			   e1:SetHintTiming(0,0x11e0)
			   e1:SetRange(LOCATION_GRAVE)
			   e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			   e1:SetTarget(c10700283.spelltg)
			   e1:SetOperation(c10700283.spellop)
			   tc:RegisterEffect(e1)
			   end
			 elseif tc:IsType(TYPE_TRAP) and tc:IsSSetable() then
			   Duel.DisableShuffleCheck()
			   if tc and Duel.SSet(tp,tc)~=0 then
				  local e1=Effect.CreateEffect(e:GetHandler())
				  e1:SetType(EFFECT_TYPE_SINGLE)
				  e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				  e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				  tc:RegisterEffect(e1)
			   end
			end
	else
		Duel.DisableShuffleCheck()
		Duel.MoveSequence(tc,1)
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c10700283.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c10700283.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end