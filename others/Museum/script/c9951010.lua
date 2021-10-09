--fate·阿尔托莉雅·潘德拉贡
function c9951010.initial_effect(c)
	  --summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951010,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c9951010.otcon)
	e1:SetOperation(c9951010.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9951010.spcon)
	e1:SetCost(c9951010.spcost)
	e1:SetTarget(c9951010.sptg)
	e1:SetOperation(c9951010.spop)
	c:RegisterEffect(e1)
 --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c9951010.reptg)
	e2:SetValue(c9951010.repval)
	e2:SetOperation(c9951010.repop)
	c:RegisterEffect(e2)
--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951010,2))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCondition(c9951010.sumcon)
	e4:SetCost(c9951010.sumcost)
	e4:SetTarget(c9951010.sumtg)
	e4:SetOperation(c9951010.sumop)
	c:RegisterEffect(e4)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951010.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951010.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951010,0))
end
function c9951010.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_LINK+SUMMON_TYPE_ADVANCE)
end
function c9951010.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c9951010.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c9951010.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c9951010.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9951010.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9951010.cfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c9951010.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9951010.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and c:GetFlagEffect(9951010)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9951010.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(9951010,RESET_CHAIN,0,1)
end
function c9951010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c9951010.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function c9951010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9951010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9951010.filter2(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c9951010.filter2(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c9951010.filter2,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9951010.filter2,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c9951010.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if fg:GetCount()>1 and ft==1 then fg=fg:Select(tp,1,1,nil) end
	local tc=fg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=fg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c9951010.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c9951010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9951010.filter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9951010.repval(e,c)
	return c9951010.filter(c,e:GetHandlerPlayer())
end
function c9951010.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
