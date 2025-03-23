--黑森林的先知
function c61701020.initial_effect(c)
	aux.AddCodeList(c,61701001)
	c:SetSPSummonOnce(61701020)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WINDBEAST),1,1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1153)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c61701020.settg)
	e1:SetOperation(c61701020.setop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c61701020.sptg)
	e2:SetOperation(c61701020.spop)
	c:RegisterEffect(e2)
end
function c61701020.setfilter(c,e,tp)
	return aux.IsCodeListed(c,61701001) and (c:IsSSetable() or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0)
end
function c61701020.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c61701020.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c61701020.sfilter(c)
	return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c61701020.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c61701020.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SSet(tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
	if Duel.IsExistingMatchingCard(c61701020.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(61701020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tc=Duel.SelectMatchingCard(tp,c61701020.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			Duel.HintSelection(Group.FromCards(tc))
			if tc:IsPosition(POS_FACEUP_ATTACK) then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
				Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			else
				local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
				Duel.ChangePosition(tc,pos)
			end
		end
	end
end
function c61701020.mfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701020.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg) or c:IsLinkSummonable(mg)
end
function c61701020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c61701020.mfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		return Duel.IsExistingMatchingCard(c61701020.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c61701020.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c61701020.mfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.GetMatchingGroup(c61701020.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if sc:IsType(TYPE_XYZ) then
		Duel.XyzSummon(tp,sc,g,1,6)
	else
		Duel.LinkSummon(tp,sc,g)
	end
end
