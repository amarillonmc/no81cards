--晶导算使 自增普拉斯
-------------------------------------check---------------------------
VHisc_JDSS=VHisc_JDSS or {}
function VHisc_JDSS.addcheck(c)
	if not VHisc_JDSS.global_check then
		VHisc_JDSS.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(VHisc_JDSS.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function VHisc_JDSS.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetReasonEffect() and tc:GetReasonEffect():IsHasType(EFFECT_TYPE_ACTIONS) and tc:GetReasonEffect():GetHandler().SetCard_JDSS then
			tc:RegisterFlagEffect(33201401,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid( 33201401,1))
		end
		tc=eg:GetNext()
	end
end
-----------------------------card effect-----------------------------------

function c33201401.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	VHisc_JDSS.addcheck(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33201401,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,33201401)
	e0:SetCondition(c33201401.tdcon1)
	e0:SetTarget(c33201401.sptg)
	e0:SetOperation(c33201401.spop)
	c:RegisterEffect(e0) 
	local e5=e0:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c33201401.tdcon2)
	c:RegisterEffect(e5)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33201401,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33201401+10000)
	e1:SetTarget(c33201401.thtg)
	e1:SetOperation(c33201401.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33201401,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c33201401.thcon1)
	e4:SetTarget(c33201401.thtg1)
	e4:SetOperation(c33201401.thop1)
	c:RegisterEffect(e4)   
end

c33201401.SetCard_JDSS=true 
function c33201401.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201401.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201401.filter1(c,e,tp)
	return c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c33201401.filter2,tp,LOCATION_HAND,0,1,c,e,tp,c:GetLevel())
end
function c33201401.filter2(c,e,tp,lv)
	return c:IsLevelAbove(0) 
		and Duel.IsExistingMatchingCard(c33201401.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel()+lv)
end
function c33201401.spfilter(c,e,tp,lv)
	return c.SetCard_JDSS and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33201401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33201401.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c33201401.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c33201401.filter2,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
--
	local x=0
	local y=0
	local tc=g1:GetFirst()
	while tc do
		y=tc:GetOriginalLevel()
		x=x+y
		tc=g1:GetNext()
	end
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33201401.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33201401.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():RegisterFlagEffect(33201401,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201401,1))
	end
end
--
function c33201401.thfilter(c)
	return c.SetCard_JDSS and not c:IsCode(33201401) and c:IsAbleToHand()
end
function c33201401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33201401.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c33201401.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33201401.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c33201401.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33201401)~=0
end
function c33201401.thfilter1(c)
	return c:IsCode(33201401) and c:IsAbleToHand()
end
function c33201401.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33201401.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33201401.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c33201401.thfilter1,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end


