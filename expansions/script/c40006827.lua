--睿智之蓝 LV3-改4
function c40006827.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableUnsummonable()
	aux.EnablePendulumAttribute(c,false) 
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c40006827.hspcon)
	e1:SetOperation(c40006827.hspop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,40006827)
	e2:SetTarget(c40006827.target)
	e2:SetOperation(c40006827.operation)
	c:RegisterEffect(e2)
--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_DECK)
	e6:SetCondition(c40006827.con6)
	e6:SetTarget(c40006827.sptg)
	e6:SetOperation(c40006827.spop)
	c:RegisterEffect(e6)
end
c40006827.lvupcount=1
c40006827.lvup={40006762}
function c40006827.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c40006827.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c40006827.filter2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40006827.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40006827.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsAbleToGrave()
		and Duel.IsExistingTarget(c40006827.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c40006827.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40006827.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.SendtoGrave(g,nil,REASON_EFFECT)==2 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c40006827.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c40006827.hspfilter(c,tp)
	return c:IsCode(40006826) and c:IsControler(tp)
end
function c40006827.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=0
	if Duel.CheckReleaseGroup(tp,c40006827.hspfilter,1,nil,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.CheckReleaseGroupEx(tp,Card.IsCode,1,e:GetHandler(),40006826)
end
function c40006827.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		g=Duel.SelectReleaseGroupEx(tp,Card.IsCode
,1,1,e:GetHandler(),40006826)
	else
		g=Duel.SelectReleaseGroup(tp,c40006827.hspfilter,1,1,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40006827,0))
end
function c40006827.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_EXTRA)
end
function c40006827.filter(c,e,tp)
	return c:IsCode(40006762) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40006827.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40006827.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40006827.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40006827.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end