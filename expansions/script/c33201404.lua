--晶导算使 倍联姆缇普莱
xpcall(function() require("expansions/script/c33201401") end,function() require("script/c33201401") end)
function c33201404.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	VHisc_JDSS.addcheck(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33201404,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,33201404)
	e0:SetCondition(c33201404.tdcon1)
	e0:SetTarget(c33201404.sptg)
	e0:SetOperation(c33201404.spop)
	c:RegisterEffect(e0)
	local e5=e0:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c33201404.tdcon2)
	c:RegisterEffect(e5)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33201404,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33201404+10000)
	e1:SetTarget(c33201404.sptg1)
	e1:SetOperation(c33201404.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33201404,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c33201404.stcon)
	e4:SetCost(c33201404.stcost)
	e4:SetTarget(c33201404.sttg)
	e4:SetOperation(c33201404.stop)
	c:RegisterEffect(e4)   
end
c33201404.SetCard_JDSS=true 
function c33201404.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201404.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201404.filter1(c,e,tp)
	return c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c33201404.filter2,tp,LOCATION_HAND,0,1,c,e,tp,c:GetLevel())
end
function c33201404.filter2(c,e,tp,lv)
	--if not math.mod(lv,c:GetLevel())==0 then return end
	return c:IsLevelAbove(0) 
		and Duel.IsExistingMatchingCard(c33201404.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv*c:GetLevel())
end
function c33201404.spfilter(c,e,tp,lv)
	return c.SetCard_JDSS and c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33201404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33201404.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c33201404.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c33201404.filter2,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetLevel())
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
		x=tc*tc2
	end
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33201404.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33201404.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c33201404.desfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(0)
end
function c33201404.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE+LOCATION_MZONE) and c33201404.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33201404.desfilter,tp,LOCATION_PZONE+LOCATION_MZONE,LOCATION_PZONE+LOCATION_MZONE,1,1,nil)
end
function c33201404.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetLevel()*tc:GetLevel()*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
--
function c33201404.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33201401)~=0 
end
function c33201404.refilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function c33201404.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33201404.refilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33201404.refilter,tp,LOCATION_PZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function c33201404.thfilter(c,lv)
	return c:IsFaceup() and c.SetCard_JDSS and c:IsType(TYPE_PENDULUM) and c:GetOriginalLevel()~=lv and not c:IsForbidden()
end
function c33201404.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c33201404.thfilter,tp,LOCATION_EXTRA,0,1,nil,lv) end
end
function c33201404.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33201404,3))
		local g=Duel.SelectMatchingCard(tp,c33201404.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end