--星辉观星者 阿斯忒西亚
function c9910601.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910601,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910601)
	e1:SetCondition(c9910601.spcon)
	e1:SetTarget(c9910601.sptg)
	e1:SetOperation(c9910601.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910602)
	e2:SetTarget(c9910601.thtg)
	e2:SetOperation(c9910601.thop)
	c:RegisterEffect(e2)
end
function c9910601.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c9910601.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910601.cfilter,1,nil,tp)
end
function c9910601.tfilter(c,typ)
	return c:IsType(typ) and c:IsFaceup()
end
function c9910601.tgfilter1(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToGrave()
end
function c9910601.tgselect(g,typ)
	if bit.band(typ,1)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_FUSION)~=1 then return false end
	if bit.band(typ,2)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)~=1 then return false end
	if bit.band(typ,4)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_XYZ)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_XYZ)~=1 then return false end
	if bit.band(typ,8)==0 then
		if g:FilterCount(Card.IsType,nil,TYPE_LINK)~=0 then return false end
	elseif g:FilterCount(Card.IsType,nil,TYPE_LINK)~=1 then return false end
	return true
end
function c9910601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local onf=LOCATION_MZONE
	local gra=LOCATION_GRAVE
	local typ=0
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_LINK) then typ=typ+8 end
	local g=Duel.GetMatchingGroup(c9910601.tgfilter1,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and typ>0 and g:CheckSubGroup(c9910601.tgselect,1,4,typ) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c9910601.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local onf=LOCATION_MZONE
	local gra=LOCATION_GRAVE
	local typ=0
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_FUSION)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_FUSION) then typ=typ+1 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_SYNCHRO)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_SYNCHRO) then typ=typ+2 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_XYZ)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_XYZ) then typ=typ+4 end
	if Duel.IsExistingMatchingCard(c9910601.tfilter,tp,onf,onf,1,nil,TYPE_LINK)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,gra,gra,1,nil,TYPE_LINK) then typ=typ+8 end
	local g=Duel.GetMatchingGroup(c9910601.tgfilter1,tp,LOCATION_EXTRA,0,nil)
	if typ==0 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9910601.tgselect,false,1,4,typ)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9910601.desfilter(c,e)
	return (c9910601.filter1(c) or c9910601.filter2(c) or c9910601.filter3(c)) and c:IsCanBeEffectTarget(e)
end
function c9910601.filter1(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c9910601.filter2(c)
	return c:IsLocation(LOCATION_FZONE)
end
function c9910601.filter3(c)
	return c:IsFaceup() and c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c9910601.fselect(g)
	if #g==1 then return true end
	return g:FilterCount(c9910601.filter1,nil)<2 and g:FilterCount(c9910601.filter2,nil)<2 and g:FilterCount(c9910601.filter3,nil)<2
end
function c9910601.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9910601.desfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(c9910601.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c9910601.fselect,false,1,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c9910601.ctfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c9910601.tgfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9910601.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 or Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local turnp=Duel.GetTurnPlayer()
	local sg=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c9910601.tgfilter2,turnp,LOCATION_DECK,0,nil)
	local ct1=og:FilterCount(c9910601.ctfilter,nil,turnp)
	if ct1>0 and #g1>=ct1 and Duel.SelectYesNo(turnp,aux.Stringid(9910601,1)) then
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(turnp,ct1,ct1,nil)
		sg:Merge(sg1)
	end
	local g2=Duel.GetMatchingGroup(c9910601.tgfilter2,1-turnp,LOCATION_DECK,0,nil)
	local ct2=og:FilterCount(c9910601.ctfilter,nil,1-turnp)
	if ct2>0 and #g2>=ct2 and Duel.SelectYesNo(1-turnp,aux.Stringid(9910601,1)) then
		Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
		local sg2=g2:Select(1-turnp,ct2,ct2,nil)
		sg:Merge(sg2)
	end
	if #sg>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
