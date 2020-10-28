--嗜血医治者
function c9910611.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,c9910611.lcheck)
	--special summon 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910611,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910611)
	e1:SetTarget(c9910611.sptg1)
	e1:SetOperation(c9910611.spop1)
	c:RegisterEffect(e1)
	--special summon 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910611,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910612)
	e2:SetTarget(c9910611.sptg2)
	e2:SetOperation(c9910611.spop2)
	c:RegisterEffect(e2)
end
function c9910611.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1 or g:GetClassCount(Card.GetLinkAttribute)==1
end
function c9910611.rmfilter1(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910611.spfilter1(c,e,tp,id)
	return c:GetTurnID()<id and not c:IsReason(REASON_RETURN)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9910611.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE 
	local id=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910611.rmfilter1(chkc,id) end
	if chk==0 then return Duel.IsExistingTarget(c9910611.rmfilter1,tp,loc,loc,4,nil,id)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910611.spfilter1,tp,loc,0,1,nil,e,tp,id) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910611.rmfilter1,tp,loc,loc,4,4,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910611.spop1(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE 
	local id=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910611.spfilter1),tp,loc,0,nil,e,tp,id)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)~=0
		and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c9910611.rmfilter2(c,id)
	return c:GetTurnID()<id and not c:IsReason(REASON_RETURN) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910611.spfilter2(c,e,tp,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9910611.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_GRAVE 
	local id=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910611.rmfilter2(chkc,id) end
	if chk==0 then return Duel.IsExistingTarget(c9910611.rmfilter2,tp,loc,0,4,nil,id)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910611.spfilter2,tp,loc,loc,1,nil,e,tp,id) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910611.rmfilter2,tp,loc,0,4,4,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910611.spop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE 
	local id=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910611.spfilter2),tp,loc,loc,nil,e,tp,id)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)~=0
		and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
