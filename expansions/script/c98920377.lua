--自奏圣乐·皮格马利翁
function c98920377.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c98920377.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920377,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,98930377)
	e2:SetCondition(c98920377.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920377.sptg2)
	e2:SetOperation(c98920377.spop2)
	c:RegisterEffect(e2)
 --Trap activate in set turn
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e12:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e12:SetRange(LOCATION_REMOVED)
	e12:SetTargetRange(LOCATION_SZONE,0)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x11b))
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e13)
--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x11b))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920377,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920377)
	e2:SetCondition(c98920377.tdcon1)
	e2:SetTarget(c98920377.tdtg)
	e2:SetOperation(c98920377.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c98920377.tdcon2)
	c:RegisterEffect(e3) 
   --change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(98920377)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c98920377.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTarget(c98920377.tg)
	e3:SetCondition(c98920377.recon)
	e3:SetOperation(c98920377.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
--
if not c98920377.globle_check then
		c98920377.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(c98920377.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c98920377.actarget)
		ge1:SetOperation(c98920377.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_ACTIVATE_COST)
		ge3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge3:SetCost(aux.FALSE)
		ge3:SetTargetRange(1,1)
		ge3:SetTarget(c98920377.actarget2)
		Duel.RegisterEffect(ge3,0)
		local g=Duel.GetMatchingGroup(c98920377.filter2,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local ge2=te:Clone()
			ge2:SetDescription(aux.Stringid(98920377,1))
			ge2:SetType(EFFECT_TYPE_QUICK_O)
			ge2:SetCode(EVENT_FREE_CHAIN)
			ge2:SetRange(LOCATION_HAND)
			ge2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			tc:RegisterEffect(ge2)
		end
	end
end
function c98920377.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98920377.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98920377.sop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then e:GetHandler():RegisterFlagEffect(98920377,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1) end
end
function c98920377.filter(c)
	return c:IsSetCard(0x11b) and c:IsType(TYPE_MONSTER)
end
function c98920377.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c98920377.scfilter(c,mg)
	return mg:IsExists(c98920377.cfilter,1,nil,c)
end
function c98920377.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98920377)>0 or (ep~=tp and e:GetCode()~=EVENT_CHAIN_NEGATED))
end
function c98920377.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920377.filter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920377.reop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	local g1=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	local g2=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,mg)
	if mg:GetCount()>0 and (g1:GetCount()>0 or g2:GetCount()>0) then
	  if Duel.SelectYesNo(tp,aux.Stringid(98920377,0)) then	 
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectOption(tp,1165,1166)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg1:GetFirst(),nil)
		elseif g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg2:GetFirst(),mg)
		 end
	   end
	end
end
function c98920377.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c98920377.spfilter(c,e,tp)
	return c:IsSetCard(0x11b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920377.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920377.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920377.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920377.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920377.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x11b)
end
function c98920377.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c98920377.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920377.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c98920377.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c98920377.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98920377.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920377.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920377.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98920377.filter1(c,e,tp)
	return c:IsSetCard(0x11b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920377.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(98920377,5)) then
		   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920377.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		   if g:GetCount()>0 then	 
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		   end
		end
	end
end
function c98920377.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,98920377) 
end
function c98920377.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x11b) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND)
end
function c98920377.costop(e,tp,eg,ep,ev,re,r,rp)
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
	ge3:SetOperation(c98920377.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c98920377.actarget2(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x11b) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE)
end
function c98920377.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
function c98920377.filter2(c)
	return c:IsSetCard(0x11b) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) 
end