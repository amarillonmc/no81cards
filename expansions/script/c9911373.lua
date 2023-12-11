--雪狱之罪人 孤行
function c9911373.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9911373)
	e1:SetTarget(c9911373.thtg)
	e1:SetOperation(c9911373.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(c9911373.thcon)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9911374)
	e4:SetCondition(c9911373.descon)
	e4:SetCost(c9911373.descost)
	e4:SetTarget(c9911373.destg)
	e4:SetOperation(c9911373.desop)
	c:RegisterEffect(e4)
end
function c9911373.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c9911373.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,LOCATION_HAND,nil)+3
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct
	end
end
function c9911373.tgfilter(c,mg)
	return c:IsSetCard(0xc956) and c:IsAbleToGrave() and mg:IsExists(Card.IsAbleToHand,1,c)
end
function c9911373.gselect(g,mg)
	return mg:IsExists(Card.IsAbleToHand,1,g)
end
function c9911373.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsPublic,tp,LOCATION_HAND,LOCATION_HAND,nil)+3
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local tg=g:Filter(c9911373.tgfilter,nil,g)
	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911373,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=tg:SelectSubGroup(tp,c9911373.gselect,false,1,2,g)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:FilterSelect(tp,Card.IsAbleToHand,1,1,sg):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c9911373.descon(e,tp,eg,ep,ev,re,r,rp)
	local b1=re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)&ATTRIBUTE_WATER>0
	local b2=(re:GetActiveType()==TYPE_SPELL or re:IsActiveType(TYPE_QUICKPLAY) or re:GetActiveType()==TYPE_TRAP)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	return b1 or b2
end
function c9911373.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9911373.repop)
end
function c9911373.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(c9911373.spcon)
	e1:SetOperation(c9911373.spop)
	Duel.RegisterEffect(e1,tp)
end
function c9911373.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c9911373.spfilter(c,e,tp)
	return c:IsSetCard(0xc956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c9911373.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c9911373.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911373.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c9911373.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911373)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911373.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911373.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9911373.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
