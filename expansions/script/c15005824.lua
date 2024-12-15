local m=15005824
local cm=_G["c"..m]
cm.name="天翎渊的本手"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tgfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(cm.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local pc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if pc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(66)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			pc:RegisterEffect(e1)
		end
	end
end
function cm.syncfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5f43) and c:IsSynchroSummonable(nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.syncfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.syncfilter,tp,LOCATION_EXTRA,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.syncfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end