--血腥与黄昏散去
local m=60000058
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	c:RegisterEffect(e1) 
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--Effect 3 
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.tg1)
	e5:SetOperation(cm.op1)
	c:RegisterEffect(e5) 
end
--Effect 1
function cm.cfilter(c)
	return c:IsSetCard(0x62a) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 and (#g==0 or (#g>0 and g:FilterCount(cm.cfilter,nil)==#g)) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--Effect 3 
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cm.todeckfilter(c)
	return  c:IsFacedown() and c:IsAbleToDeck()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.todeckfilter,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(cm.todeckfilter,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetFlagEffect(m)==0 end
	local g=Duel.GetMatchingGroup(cm.todeckfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.todeckfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(1-tp,cm.todeckfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 and g1:GetCount()>0 then
		g:Merge(g1)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
