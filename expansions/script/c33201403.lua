--
xpcall(function() require("expansions/script/c33201401") end,function() require("script/c33201401") end)
function c33201403.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	VHisc_JDSS.addcheck(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33201403,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,33201403)
	e0:SetCondition(c33201403.tdcon1)
	e0:SetTarget(c33201403.sptg)
	e0:SetOperation(c33201403.spop)
	c:RegisterEffect(e0) 
	local e5=e0:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c33201403.tdcon2)
	c:RegisterEffect(e5)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33201403,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33201403+10000)
	e1:SetCost(c33201403.spcost1)
	e1:SetTarget(c33201403.sptg1)
	e1:SetOperation(c33201403.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33201403,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c33201403.descon)
	e4:SetTarget(c33201403.destg)
	e4:SetOperation(c33201403.desop)
	c:RegisterEffect(e4)  
end
c33201403.SetCard_JDSS=true 
function c33201403.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201403.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201403.filter1(c,e,tp)
	return c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c33201403.filter2,tp,LOCATION_HAND,0,1,c,e,tp,c:GetLevel())
end
function c33201403.filter2(c,e,tp,lv)
	--if not math.mod(lv,c:GetLevel())==0 then return end
	return c:IsLevelAbove(0) 
		and Duel.IsExistingMatchingCard(c33201403.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv/c:GetLevel())
end
function c33201403.spfilter(c,e,tp,lv)
	return c.SetCard_JDSS and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33201403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33201403.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c33201403.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c33201403.filter2,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
--
	local x=0
	local y=0
	local tc=g1:GetFirst():GetOriginalLevel()
	local tc2=g1:GetNext():GetOriginalLevel()
	if tc<tc2 then
		x=tc2/tc
	else
		x=tc/tc2
	end
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33201403.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33201403.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c33201403.thfilter(c)
	return c.SetCard_JDSS and not c:IsCode(33201403) and c:IsAbleToHand()
end
function c33201403.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c33201403.costfilter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalLevel()>0 and Duel.IsExistingMatchingCard(c33201403.spfilter1,tp,LOCATION_DECK,0,2,nil,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>1 
end
function c33201403.spfilter1(c,tc,e,tp)
	return c.SetCard_JDSS and c:GetOriginalLevel()==tc:GetOriginalLevel()/2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33201403.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33201403.costfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	e:SetLabel(0)
	local g=Duel.SelectMatchingCard(tp,c33201403.costfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c33201403.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.GetMatchingGroup(c33201403.spfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tc,e,tp)
	if sg:GetCount()==0 then return end
	local hg=sg:Select(tp,1,1,nil)
	sg:RemoveCard(hg:GetFirst())
	sg=sg:Filter(Card.IsCode,nil,hg:GetFirst():GetCode())
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		hg:Merge(tg)
		Duel.SpecialSummon(hg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c33201403.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33201401)~=0 and eg:IsExists(c33201403.cfilter,1,nil,1-tp) and rp==1-tp
end
function c33201403.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33201403.cfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,eg:GetCount(),0,0)
end
function c33201403.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) 
end
function c33201403.filter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c33201403.cfilter(c) and c:IsRelateToEffect(e)
end
function c33201403.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33201403.filter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
