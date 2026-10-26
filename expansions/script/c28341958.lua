--羁绊的一等星 完美三角形
function c28341958.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1,28341958+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28341958.target)
	e1:SetOperation(c28341958.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+28322511)
	e2:SetOperation(c28341958.repop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(28322511)
	e0:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e0)
	--global
	if not ILLUMINA_REPLACE_GLOBAL then
		ILLUMINA_REPLACE_GLOBAL = true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_SEND_REPLACE)
		ge1:SetTarget(c28341958.reptg)
		ge1:SetValue(aux.FALSE)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28341958.tfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x284) and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c28341958.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c28341958.spfilter(c,e,tp,tc)
	return not c:IsAttribute(tc:GetAttribute()) and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:IsSetCard(0x284) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28341958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28341958.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c28341958.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28341958.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28341958.cfilter(c,attr)
	return c:IsLevelAbove(1) and c:IsFaceup() and c:IsAttribute(attr)
end
function c28341958.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28341958.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or tc:IsFacedown() or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c28341958.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if sg:GetCount()==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c28341958.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(c28341958.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28341958,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28341958.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c28341958.repfilter(c)
	return c:IsHasEffect(28322511) and c:GetDestination()==LOCATION_DECK --and c:IsLocation(LOCATION_GRAVE)
end
function c28341958.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c28341958.repfilter,nil)
	if chk==0 then return #tg>0 and bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) end
	for p in aux.TurnPlayers() do
		local g=tg:Filter(Card.IsControler,nil,p)
		local ops,t={aux.Stringid(28384553,3)},{}
		for tc in aux.Next(g) do table.insert(ops,aux.Stringid(tc:GetOriginalCode(),0)) table.insert(t,tc) end
		if #g>1 then
			while #t>1 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RESOLVEEFFECT)
				local sel=Duel.SelectOption(p,table.unpack(ops))
				if sel~=0 then
					local tc=t[sel]
					Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0)
					--tc.replace_operation(e,p,eg,ep,ev,re,r,rp)
					table.remove(ops,sel+1)
					table.remove(t,sel)
				else break end
			end
		end
		for _,tc in ipairs(t) do Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0) end
	end
	return false
end
function c28341958.lvfilter(c)
	return c:IsLevelAbove(1) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c28341958.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28341958)
	local g=Duel.GetMatchingGroup(c28341958.lvfilter,tp,LOCATION_MZONE,0,nil)
	if g<2 or g:GetClassCount(Card.GetLevel)==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
	Duel.HintSelection(sg)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28341958,1))
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local lv=sg:Filter(aux.TRUE,tc):GetFirst():GetLevel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
