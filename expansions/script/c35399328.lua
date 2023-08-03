--疾 行 机 人 玩 具 坦 克
local m=35399328
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399328,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,35399328)
	e1:SetCost(c35399328.spcost)
	e1:SetTarget(c35399328.sptg)
	e1:SetOperation(c35399328.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399328,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,35398328)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCondition(c35399328.sppcon)
	e3:SetTarget(c35399328.spptg)
	e3:SetOperation(c35399328.sppop)
	c:RegisterEffect(e3)
end
function c35399328.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c35399328.spfilter1(c,e,tp)
	return c:IsSetCard(0x2016) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c35399328.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp)
end
function c35399328.spfilter2(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:GetFlagEffect(35399328)==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35399328.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c35399328.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c35399328.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	tc:RegisterFlagEffect(35399328,RESET_CHAIN,0,1)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c35399328.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35399328.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c35399328.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c35399328.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsLocation(LOCATION_EXTRA)
end
function c35399328.sppcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>1
end
function c35399328.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399328.synfilter(c,tc)
	return c:IsSynchroSummonable(tc) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c35399328.sppop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e1:SetValue(LOCATION_DECKSHF)  
			c:RegisterEffect(e1,true) 
	if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
	local lv=0
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	lv=Duel.AnnounceLevel(tp,1,5,lv)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(lv)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
			Duel.BreakEffect()
	if not c:IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(c35399328.synfilter,tp,LOCATION_EXTRA,0,1,nil,c)
	and Duel.SelectYesNo(tp,aux.Stringid(35399328,1)) then
	local g=Duel.GetMatchingGroup(c35399328.synfilter,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
	end
	end
	end
end

