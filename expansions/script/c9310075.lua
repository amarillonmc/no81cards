--单调秘械
function c9310075.initial_effect(c)
	aux.AddMaterialCodeList(c,15005130)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,15005130),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9310075,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9310075)
	e1:SetTarget(c9310075.target)
	e1:SetOperation(c9310075.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c9310075.tnval)
	c:RegisterEffect(e3)
	 --special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9310075,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9311075)
	e4:SetCondition(c9310075.spcon)
	e4:SetTarget(c9310075.sptg)
	e4:SetOperation(c9310075.spop)
	c:RegisterEffect(e4)
end
function c9310075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9310075.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9310075.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local sc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(tp,sc)
	Duel.ConfirmCards(1-tp,sc)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if sc:IsCode(ac) and sc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(sc,nil,REASON_EFFECT)~=0 
			and sc:IsLocation(LOCATION_HAND) and sc:IsType(TYPE_TUNER)
			and (sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.IsExistingMatchingCard(c9310075.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp))
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9310075,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=Duel.GetMatchingGroup(c9310075.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			sg:Merge(Group.FromCards(sc))
			tc=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.ShuffleHand(tp)
		else
		Duel.ShuffleHand(tp)
		end
	else
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	end
end
function c9310075.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310075.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9310075.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9310075.cfilter,1,nil,tp)
end
function c9310075.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9310075.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end