--魔导神士 朱诺
function c14824033.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),7,3)
	c:EnableReviveLimit()
	--xyz summon2
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(14824033,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,14824033)
	e0:SetCost(c14824033.spcost)
	e0:SetTarget(c14824033.sptg)
	e0:SetOperation(c14824033.spop)
	c:RegisterEffect(e0)
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(14824033)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x106e))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c14824033.ovlcon)
	e3:SetOperation(c14824033.ovlop)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(14824033,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,14824034)
	e5:SetCost(c14824033.thcost)
	e5:SetTarget(c14824033.thtg)
	e5:SetOperation(c14824033.thop)
	c:RegisterEffect(e5)
	--
	if not c14824033.globle_check then
		c14824033.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(c14824033.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c14824033.actarget)
		ge1:SetOperation(c14824033.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_ACTIVATE_COST)
		ge3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge3:SetCost(aux.FALSE)
		ge3:SetTargetRange(1,1)
		ge3:SetTarget(c14824033.actarget2)
		Duel.RegisterEffect(ge3,0)
		local g=Duel.GetMatchingGroup(c14824033.filter2,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local ge2=te:Clone()
			ge2:SetDescription(aux.Stringid(14824033,1))
			ge2:SetType(EFFECT_TYPE_QUICK_O)
			ge2:SetCode(EVENT_FREE_CHAIN)
			ge2:SetRange(LOCATION_HAND)
			ge2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			tc:RegisterEffect(ge2)
		end
	end
end
function c14824033.cffilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c14824033.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14824033.cffilter,tp,LOCATION_HAND,0,3,nil) and Duel.GetFlagEffect(tp,14824033)==0 end
	Duel.RegisterFlagEffect(tp,14824033,RESET_CHAIN,0,1)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c14824033.cffilter,tp,LOCATION_HAND,0,3,3,nil)
	e:SetLabelObject(g)
	g:KeepAlive()
	Duel.ConfirmCards(1-tp,g)
	
end
function c14824033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14824033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.GetLocationCountFromEx(tp)>0) then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	Duel.ShuffleHand(tp)
end
function c14824033.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,14824033) 
end
function c14824033.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x106e) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND)
end
function c14824033.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c14824033.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c14824033.actarget2(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x106e) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE)
end
function c14824033.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
function c14824033.filter2(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) 
end
function c14824033.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetFlagEffect(tp,952523)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:GetLocation()~=LOCATION_OVERLAY 
end
function c14824033.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	rc:CancelToGrave()
	Duel.Overlay(e:GetHandler(),rc)
end
function c14824033.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetMatchingGroupCount(c14824033.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c14824033.thfilter(c)
	return c:IsSetCard(0x106e) and c:IsAbleToHand()
end
function c14824033.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14824033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14824033.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c14824033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14824033.thfilter,tp,LOCATION_DECK,0,e:GetLabel(),e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c14824033.spfilter,tp,LOCATION_DECK,0,1,nil,g:GetCount(),e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(14824033,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c14824033.spfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetCount(),e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
