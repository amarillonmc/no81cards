local m=82206095
local cm=_G["c"..m]
cm.name="六界帝神"
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,82206092),aux.FilterBoolFunction(Card.IsFusionSetCard,0x29b),true)  
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e1)
	--to deck 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TODECK)  
	e3:SetType(EFFECT_TYPE_QUICK_O)   
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
	e3:SetTarget(cm.tdtg)  
	e3:SetOperation(cm.tdop)  
	c:RegisterEffect(e3)  
	--special summon  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMING_END_PHASE)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCondition(cm.spcon)
	e4:SetCost(cm.spcost)  
	e4:SetTarget(cm.sptg)  
	e4:SetOperation(cm.spop)  
	c:RegisterEffect(e4)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)  
end  
function cm.filter1(c,e,tp)  
	return c:IsFaceup() and c:IsCode(82206092) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)  
		and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp)  
end  
function cm.filter2(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0x29b) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,REASON_RULE) end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,REASON_RULE)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,REASON_RULE)
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.SendtoDeck(g,nil,2,REASON_RULE)  
	end  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()~=tp  
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if g:GetCount()==0 then return end  
	if g:GetCount()<=ft then  
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)  
	else  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sg=g:Select(tp,ft,ft,nil)  
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)   
	end  
end  
