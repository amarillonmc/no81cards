--王之名
local m=98500303
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,10000010,10000020,10000000,98500311,39913299)
	aux.EnableChangeCode(c,39913299,LOCATION_HAND+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)
end
function cm.tgfilter2(c)
	return c:IsCode(98500311) and c:IsFaceup()
end
function cm.srfilter(c)
	return (aux.IsCodeListed(c,10000000) or aux.IsCodeListed(c,10000010) or aux.IsCodeListed(c,10000020) or c:IsCode(5253985,7373632,59094601,39913299,79339613,42469671,85758066,85182315,79868386,32247099,269012,10000000,10000010,10000020,79387392)) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(10) and (c:IsAttribute(ATTRIBUTE_DIVINE) or c:IsRace(RACE_DIVINE)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	--splimit
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cm.splimit)
	Duel.RegisterEffect(e0,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function cm.splimit(e,c)
	return c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLocation(LOCATION_HAND)
end
function cm.rlcheck(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) or c:IsRace(RACE_DIVINE)
end