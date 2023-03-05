--深渊异龙的导引
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tgf1(c)
	return c:IsAbleToGrave() and c:GetType()&0x81==0x81 and c:IsRace(RACE_DRAGON)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.opf1(c)
	return c:GetLevel()>0 and c:IsSetCard(0x9fd5) and c:IsAbleToDeck()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local g1=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(cm.opf1,tp,LOCATION_GRAVE,0,nil)
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and aux.RitualUltimateFilter(tc,nil,e,tp,g1,g2,Card.GetLevel,"Greater") and Duel.SelectYesNo(tp,1168) then 
		if tc:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
		g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.opf1),tp,LOCATION_GRAVE,0,nil)
		g1=(g1:Filter(Card.IsCanBeRitualMaterial,tc,tc)+g2):Filter(tc.mat_filter and tc.mat_filter or aux.TRUE,tc,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		g1=g1:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not g1 or #g1==0 then return end
		tc:SetMaterial(g1)
		g2=g1:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsSetCard,nil,0x9fd5)
		g1:Sub(g2)
		Duel.ReleaseRitualMaterial(g1)
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		Duel.Hint(24,0,aux.Stringid(m,0))
	end
end
