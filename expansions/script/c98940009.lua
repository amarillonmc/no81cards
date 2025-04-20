--自奏圣乐·爱神之奇迹
function c98940009.initial_effect(c)
	c:EnableReviveLimit()
--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,98940009)
	e2:SetCondition(c98940009.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98940009.sptg2)
	e2:SetOperation(c98940009.spop2)
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
	local e17=e1:Clone()
	e17:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfe))
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e18)
   --change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(98940009)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
--damage
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e22:SetCode(EVENT_PHASE+PHASE_END)
	e22:SetRange(LOCATION_REMOVED)
	e22:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e22:SetCountLimit(1)
	e22:SetOperation(c98940009.damop)
	e22:SetCondition(c98940009.tdcondition)
	c:RegisterEffect(e22)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c98940009.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTarget(c98940009.tg)
	e3:SetCondition(c98940009.recon)
	e3:SetOperation(c98940009.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
--
if not c98940009.globle_check then
		c98940009.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(c98940009.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c98940009.actarget)
		ge1:SetOperation(c98940009.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_ACTIVATE_COST)
		ge3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge3:SetCost(aux.FALSE)
		ge3:SetTargetRange(1,1)
		ge3:SetTarget(c98940009.actarget2)
		Duel.RegisterEffect(ge3,0)
		local g=Duel.GetMatchingGroup(c98940009.filter2,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local ge2=te:Clone()
			ge2:SetDescription(aux.Stringid(98940009,1))
			ge2:SetType(EFFECT_TYPE_QUICK_O)
			ge2:SetCode(EVENT_FREE_CHAIN)
			ge2:SetRange(LOCATION_HAND)
			ge2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			tc:RegisterEffect(ge2)
		end
	end
end
function c98940009.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98940009.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98940009.sop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then e:GetHandler():RegisterFlagEffect(98940009,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1) end
end
function c98940009.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c98940009.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c98940009.scfilter(c,mg)
	return mg:IsExists(c98940009.cfilter,1,nil,c)
end
function c98940009.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98940009)>0 or (ep~=tp and e:GetCode()~=EVENT_CHAIN_NEGATED))
end
function c98940009.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940009.filter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98940009.xksfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c98940009.lksfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeLinkMaterial(nil)
end
function c98940009.gselect1(sg,c)
	return sg:IsExists(Card.IsSetCard,1,nil,0x11b) and c:IsXyzSummonable(sg,#sg,#sg)
end
function c98940009.xyzfilter(c,mg)
	return c:IsType(TYPE_XYZ) and mg:CheckSubGroup(c98940009.gselect1,1,#mg,c)
end
function c98940009.linkfilter(c,mg)
	return c:IsType(TYPE_LINK) and mg:CheckSubGroup(c98940009.gselect2,1,#mg,c)
end
function c98940009.gselect2(sg,c)
	return sg:IsExists(Card.IsSetCard,1,nil,0x11b) and c:IsLinkSummonable(sg,nil,#sg,#sg)
end
function c98940009.reop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c98940009.xksfilter,tp,LOCATION_MZONE,0,nil)
	local mg2=Duel.GetMatchingGroup(c98940009.lksfilter,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(c98940009.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg1)
	local g2=Duel.GetMatchingGroup(c98940009.linkfilter,tp,LOCATION_EXTRA,0,nil,mg2)
	if (mg1:GetCount()>0 and g1:GetCount()>0) or (mg2:GetCount()>0 and g2:GetCount()>0) then
	  if Duel.SelectYesNo(tp,aux.Stringid(98940009,0)) then  
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectOption(tp,1165,1166)==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg1:GetFirst(),nil)
		elseif g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg2:GetFirst(),nil)
		 end
	   end
	end
end
function c98940009.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c98940009.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98940009.tgfilter(c)
	return c:IsSetCard(0x11b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98940009.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98940009.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c98940009.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98940009.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c98940009.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0
		and sg:GetFirst():IsLocation(LOCATION_GRAVE) then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98940009.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if #g>0 then
		   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98940009.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98940009.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c98940009.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c98940009.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,98940009) 
end
function c98940009.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x11b,0xfe) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND)
end
function c98940009.costop(e,tp,eg,ep,ev,re,r,rp)
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
	ge3:SetOperation(c98940009.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c98940009.actarget2(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x11b,0xfe) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE)
end
function c98940009.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
function c98940009.filter2(c)
	return c:IsSetCard(0x11b,0xfe) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) 
end
function c98940009.tdcondition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_MACHINE)
end
function c98940009.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
	   Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
	   Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end