--骑士时刻·时王Ⅱ
function c9981149.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9981149.lcheck)
	c:EnableReviveLimit()
	--sort
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981149,1))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9981149.sttg)
	e1:SetOperation(c9981149.stop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981149,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c9981149.cost)
	e2:SetTarget(c9981149.target)
	e2:SetOperation(c9981149.operation)
	c:RegisterEffect(e2)
	--announce 3 cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981149,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9981149)
	e3:SetTarget(c9981149.sptg)
	e3:SetOperation(c9981149.spop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981149.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981149.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981149,3))
end
function c9981149.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xabcd)
end
function c9981149.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function c9981149.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,1-tp,3)
end
function c9981149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9981149.filter(c,e,tp)
	return c:IsSetCard(0x6bc3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981149.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c9981149.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9981149.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9981149.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9981149.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9981149.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil)
		or Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9981149.spop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=g:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tc=sg:GetFirst()
	if tc then
		Duel.ConfirmCards(tp,sg)
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK,tp)
		local sel=0
		if b1 and b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9981149,1),aux.Stringid(9981149,1))+1
		elseif b1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9981149,1))+1
		elseif b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9981149,0))+2
		end
		if sel==1 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif sel==2 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		end
	end
	Duel.ShuffleDeck(1-tp)
end
