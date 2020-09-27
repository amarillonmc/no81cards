--引导迷失的传承之物
function c10700286.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700286,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2,10700286)
	e1:SetTarget(c10700286.antg)
	e1:SetOperation(c10700286.anop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700286,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10700286.thcost)
	e2:SetTarget(c10700286.thtg)
	e2:SetOperation(c10700286.thop)
	c:RegisterEffect(e2)	   
end
function c10700286.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c10700286.anop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) then
			if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(10700286,2)) then
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
			   e1:SetTarget(c10700286.spelltg)
			   e1:SetOperation(c10700286.spellop)
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
function c10700286.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c10700286.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c10700286.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10700286.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700286.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end