--岭偶守护兽·飞砂追风者
function c9911651.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911651)
	e1:SetTarget(c9911651.tgtg)
	e1:SetOperation(c9911651.tgop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,9911652)
	e2:SetTarget(c9911651.thtg)
	e2:SetOperation(c9911651.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--recycle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911651,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911653)
	e4:SetCondition(c9911651.rcccon)
	e4:SetTarget(c9911651.rcctg)
	e4:SetOperation(c9911651.rccop)
	c:RegisterEffect(e4)
end
function c9911651.cffilter(c,check)
	return not c:IsPublic() and c:IsSetCard(0x5957) and (check or c:IsAbleToGrave())
end
function c9911651.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9911651.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=c:IsAbleToGrave()
	local g=Duel.GetMatchingGroup(c9911651.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c9911651.cffilter,tp,LOCATION_HAND,0,1,c,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9911651.cffilter,tp,LOCATION_HAND,0,1,1,c,check)
	local tc=g:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	g:AddCard(c)
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
end
function c9911651.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local mg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c9911651.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=mg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		if #sg1==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
function c9911651.thfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9911651.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911651.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911651.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911651.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911651.cfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c9911651.rcccon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(c9911651.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c9911651.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not g:IsExists(c9911651.ntdfilter,1,c)
end
function c9911651.ntdfilter(c)
	return not c:IsAbleToDeck()
end
function c9911651.rcctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c9911651.cfilter,nil,tp)
	g:AddCard(c)
	if chk==0 then return #g>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsExists(c9911651.spfilter,1,nil,e,tp,g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g-1,0,0)
end
function c9911651.rccop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	if #g<2 or not g:IsContains(c) or aux.NecroValleyNegateCheck(tg) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:FilterSelect(tp,c9911651.spfilter,1,1,nil,e,tp,g):GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	g:RemoveCard(tc)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
