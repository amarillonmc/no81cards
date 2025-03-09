--神威骑士团堡垒
function c24501035.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x501))
	e1:SetValue(c24501035.efilter)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	--c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24501035,0))
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+24501035)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(c24501035.tgcon)
	e4:SetTarget(c24501035.tgtg)
	e4:SetOperation(c24501035.tgop)
	c:RegisterEffect(e4)
	aux.RegisterMergedDelayedEvent(c,24501035,EVENT_SPSUMMON_SUCCESS)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24501035,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCost(c24501035.spcost)
	e5:SetTarget(c24501035.sptg)
	e5:SetOperation(c24501035.spop)
	c:RegisterEffect(e5)
end
function c24501035.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c24501035.tfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
		and lv>=2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=math.floor(lv/2)
end
function c24501035.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c24501035.tfilter,1,nil,tp)
end
function c24501035.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c24501035.tfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c24501035.thfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToHand()
end
function c24501035.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(2) then
		local lv=tc:GetLevel()
		Duel.DiscardDeck(tp,math.floor(lv/2),REASON_EFFECT)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c24501035.thfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(24501035,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c24501035.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c24501035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c24501035.spfilter(c,e,tp,eg)
	return c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsContains(c)
end
function c24501035.tdfilter(c,e,tp,eg)
	return c:IsSetCard(0x501) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingTarget(c24501035.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,eg)
end
function c24501035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c24501035.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24501035.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c24501035.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function c24501035.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
