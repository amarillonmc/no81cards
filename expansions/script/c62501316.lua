--御巫合舞-幻御奏
function c62501316.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62501316)
	e1:SetTarget(c62501316.target)
	e1:SetOperation(c62501316.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,62501316+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c62501316.sptg)
	e2:SetOperation(c62501316.spop)
	c:RegisterEffect(e2)
end
function c62501316.thfilter(c,chk)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c62501316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501316.thfilter,tp,LOCATION_DECK,0,2,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c62501316.chkfilter(c)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c62501316.gcheck(g,e,tp)
	local sc=g:GetFirst()
	local ec=g:GetNext()
	return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and ec:CheckUniqueOnField(tp) and not ec:IsForbidden() or ec:IsCanBeSpecialSummoned(e,0,tp,false,false) and sc:CheckUniqueOnField(tp) and not sc:IsForbidden()
end
function c62501316.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c62501316.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c62501316.thfilter,tp,LOCATION_DECK,0,2,2,nil,1)
	if #tg~=2 or Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	local g=Duel.GetMatchingGroup(c62501316.chkfilter,tp,LOCATION_HAND,0,nil)
	if Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and g:CheckSubGroup(c62501316.gcheck,2,2,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(62501316,0)) then
		Duel.ShuffleHand(tp)
		if #g>2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			g=g:Select(tp,2,2,nil)
		end
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		g:RemoveCard(sc)
		local ec=g:GetFirst()
		if not Duel.Equip(tp,ec,sc) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(sc)
		e1:SetValue(c62501316.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end
function c62501316.splimit(e,c)
	return not c:IsSetCard(0x18d) and c:IsLocation(LOCATION_EXTRA)
end
function c62501316.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==e:GetLabelObject()
end
function c62501316.spfilter(c,e,tp,chk)
	return (c:GetType()&TYPE_SPELL+TYPE_EQUIP)==TYPE_SPELL+TYPE_EQUIP and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62501316.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c62501316.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
function c62501316.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c62501316.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
