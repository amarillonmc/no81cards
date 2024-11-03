--绝冰之圣炎 瑞瓦伽伦&菲约尔姆
function c75099018.initial_effect(c)
	--fusion procedure
	c:SetSPSummonOnce(75099018)
	aux.AddFusionProcFun2(c,c75099018.matfilter1,c75099018.matfilter2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c75099018.splimit)
	c:RegisterEffect(e1)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c75099018.ctop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75099018)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetTarget(c75099018.sptg)
	e3:SetOperation(c75099018.spop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,75099019)
	e4:SetCondition(c75099018.spcon)
	e4:SetTarget(c75099018.sptg2)
	e4:SetOperation(c75099018.spop2)
	c:RegisterEffect(e4)
c75099018.frozen_list=true
end
function c75099018.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c75099018.matfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WARRIOR)
end
function c75099018.matfilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function c75099018.ctop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and tc:IsSummonPlayer(1-tp)
		and tc:IsCanAddCounter(0x1750,1) and tc:AddCounter(0x1750,1) and tc:GetFlagEffect(75099001)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c75099018.frcon)
			e1:SetValue(tc:GetAttack()*-1/4)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(tc:GetDefense()*-1/4)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function c75099018.frcon(e)
	return e:GetHandler():GetCounter(0x1750)>0
end
function c75099018.tdfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToExtra() and
	Duel.IsExistingMatchingCard(c75099018.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetRace())
end
function c75099018.spfilter(c,e,tp,lv,race)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)
		and c:IsRace(race) and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c75099018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c75099018.tdfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c75099018.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75099018.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c75099018.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local race=tc:GetRace()
		local lv=tc:GetLevel()
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75099018.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,race)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c75099018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c75099018.spfilter2(c,e,tp)
	return c.frozen_list and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75099018.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75099018.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75099018.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75099018.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
