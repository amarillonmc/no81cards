--龙刻龙喰
local m=40010350
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.Crimsonmoon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--Effect 2 
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetCountLimit(1,m)
	e11:SetCost(aux.bfgcost)
	e11:SetTarget(cm.sptg)
	e11:SetOperation(cm.spop)
	c:RegisterEffect(e11) 
end
--Effect 1
function cm.filter(c,e,tp)
	local ct=math.floor(c:GetLevel()/3)
	return c:IsFaceup() and c:IsReleasableByEffect()
		and bit.band(c:GetType(),0x81)==0x81
		and c:GetLevel()>2
		and Duel.GetMZoneCount(tp,c)>=ct
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,ct,nil,e,tp)
end
function cm.filter1(c,e,tp)
	return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,lv/3,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=math.floor(tc:GetLevel()/3) 
	if  tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0  then 
		local sg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetMZoneCount(tp,tc)>=ct and sg:GetCount()>=ct then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=sg:Select(tp,ct,ct,nil)
			if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
		end
	end
end
--Effect 2
function cm.spfilter(c,e,tp)
	return cm.Crimsonmoon(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end