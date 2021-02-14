--PSY骨架结合
function c30002045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30002045,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c30002045.target)
	e1:SetOperation(c30002045.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30002045,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c30002045.target2)
	e2:SetOperation(c30002045.activate2)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c30002045.handcon)
	c:RegisterEffect(e3)
end
function c30002045.thfilter(c)
	return c:IsSetCard(0xc1) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30002045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c30002045.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c30002045.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c30002045.thfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c30002045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c30002045.tgfilter1(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c30002045.tgfilter2(g,e,tp)
	local lv=g:GetSum(Card.GetLevel)
	return g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
		and Duel.IsExistingMatchingCard(c30002045.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c30002045.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c30002045.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c30002045.tgfilter1,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c30002045.tgfilter2,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30002045.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c30002045.tgfilter1,tp,LOCATION_REMOVED,0,nil)
	local sg=g:SelectSubGroup(tp,c30002045.tgfilter2,false,2,2,e,tp)
	if sg:GetCount()==0 then return end
	local lv=sg:GetSum(Card.GetLevel)
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c30002045.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if tg:GetCount()>0 then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c30002045.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
