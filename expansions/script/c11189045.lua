--湮潮使·傲
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	--
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return aux.IsCodeListed(c,0x452)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5454) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSummonable(true,nil))
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=tc:IsSummonable(true,nil)
	local op=aux.SelectFromOptions(tp,{b1,1152},{b2,aux.Stringid(id,2)})
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x452,1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:AddCounter(0x452,1)
	end
end