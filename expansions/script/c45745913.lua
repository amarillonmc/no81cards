--极翼灵兽 闪电鸟
function c45745913.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c45745913.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745913,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c45745913.destg)
	e1:SetOperation(c45745913.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745913,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,45745913)
	e2:SetCondition(c45745913.spcon1)
	e2:SetTarget(c45745913.target1)
	e2:SetOperation(c45745913.operation1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45745913,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,45745913)
	e3:SetCondition(c45745913.spcon2)
	e3:SetTarget(c45745913.target2)
	e3:SetOperation(c45745913.operation2)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(45745913,7))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,45745913)
	e4:SetCondition(c45745913.spcon3)
	e4:SetTarget(c45745913.target3)
	e4:SetOperation(c45745913.operation3)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(45745913,10))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,45745980)
	e5:SetCondition(c45745913.sccon)
	e5:SetTarget(c45745913.sctarg)
	e5:SetOperation(c45745913.scop)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(45745913,11))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,45745980)
	e6:SetCondition(c45745913.sccon1)
	e6:SetTarget(c45745913.xyztg)
	e6:SetOperation(c45745913.xyzop)
	c:RegisterEffect(e6)
end
function c45745913.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x881)
end
--e1
function c45745913.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c45745913.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--e2
function c45745913.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c45745913.filter1(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x881) 
end
function c45745913.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45745913.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745913.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c45745913.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1) then
		op=Duel.SelectOption(tp,aux.Stringid(45745913,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45745913,2),aux.Stringid(45745913,3))
	end
	e:SetLabel(op)
end
function c45745913.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c45745913.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c45745913.splimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c45745913.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x881)
end
function c45745913.splimit2(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK) and not c:IsSetCard(0x323) 
end
--e3
function c45745913.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c45745913.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x881) 
end
function c45745913.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45745913.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745913.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c45745913.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1,2) then
		op=Duel.SelectOption(tp,aux.Stringid(45745913,5))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45745913,5),aux.Stringid(45745913,6))
	end
	e:SetLabel(op)
end
function c45745913.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(2)
		else
			e1:SetValue(-2)
		end
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c45745913.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c45745913.splimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c45745913.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x881)
end
function c45745913.splimit2(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK) and not c:IsSetCard(0x323) 
end
--e4
function c45745913.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c45745913.filter3(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x881) 
end
function c45745913.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45745913.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745913.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c45745913.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1,2,3) then
		op=Duel.SelectOption(tp,aux.Stringid(45745913,8))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45745913,8),aux.Stringid(45745913,9))
	end
	e:SetLabel(op)
end
function c45745913.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(3)
		else
			e1:SetValue(-3)
		end
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c45745913.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c45745913.splimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c45745913.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x881)
end
function c45745913.splimit2(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK) and not c:IsSetCard(0x323) 
end
--e3
function c45745913.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45745913.spfilter1(c,e,tp)
	return c:IsSetCard(0x881) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45745913.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745913.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c45745913.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45745913.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e5
function c45745913.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c45745913.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(45745913)==0
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end
	c:RegisterFlagEffect(45745913,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c45745913.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
--e6
function c45745913.sccon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c45745913.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c45745913.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745913.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c45745913.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c45745913.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end