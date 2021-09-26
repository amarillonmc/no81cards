--闪刀术式-纪元之光
local m=11451480
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local count1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return count1>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then count1=1 end
	local count2=1+math.floor(Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)/3)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local max=math.min(count1,count2,#sg)
	local g=sg:SelectSubGroup(tp,aux.dncheck,false,1,max)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
end