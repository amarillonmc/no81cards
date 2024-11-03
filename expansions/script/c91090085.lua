--黑羽幼龙同步士
local cm,m=GetID()
function c91090085.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(0xff)
	e0:SetValue(9012916)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(cm.tnval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsCode(9012916)
end
function cm.spfilter1(c,e,tp)
	return c:IsLevelBelow(4)and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if #g>0 then
	tc:SetMaterial(nil)
		Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.filter1(g,e,tp)
return  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end
function cm.spfilter(c,e,tp,g)
	return  c:IsType(TYPE_SYNCHRO) and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,12)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP)
end
function cm.spfilter2(c,e,tp,g)
	return  c:IsType(TYPE_SYNCHRO) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP) and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,12)
end
function cm.fit11(g,lv)
	return g:GetSum(Card.GetLevel,c)==lv
end
function cm.fit1(c)
	return  (c:IsAbleToDeck() or c:IsAbleToExtra()) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.fit1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(cm.filter1,1,12,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.filtern(g,lv)
	return  lv==g:GetSum(Card.GetLevel,c) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.fit1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sg2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,g)
		if #sg2>0 then
		local sg=sg2:Select(tp,1,1,nil)
		local lv=sg:GetFirst():GetLevel()
		local tg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,12)
			if Duel.SendtoDeck(tg,tp,3,REASON_EFFECT)~=0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end