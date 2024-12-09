--开幕定式！
---@param c Card
yume=yume or {}
if c71403001 then
function c71403001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403001,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c71403001.con1)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(c71403001.tg1)
	e1:SetOperation(c71403001.op1)
	e1:SetValue(yume.PPTActivateZonesLimitForPlacingPend)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403001)
	Duel.AddCustomActivityCounter(71503001,ACTIVITY_SPSUMMON,c71403001.counterfilter)
	yume.PPTCounter()
end
function c71403001.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c71403001.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(71503001,tp,ACTIVITY_SPSUMMON)==0
end
function c71403001.filter1lnk(c)
	return c:IsType(TYPE_LINK) and c:IsAttack(1300) and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() or c:IsForbidden())
end
function c71403001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(yume.PPTPendFilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		return g:GetCount()>1 and g:IsExists(aux.FilterEqualFunction(Card.IsForbidden,false),1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c71403001.filter1lnk,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,tp,LOCATION_DECK)
end
function c71403001.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local lnk=Duel.SelectMatchingCard(tp,c71403001.filter1lnk,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not lnk then return end
	if Duel.MoveToField(lnk,tp,lnk:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		lnk:RegisterEffect(e1)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local pc=Duel.SelectMatchingCard(tp,yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if pc and Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local g=Duel.SelectMatchingCard(tp,yume.PPTPendFilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		end
	end
end
end
function yume.PPTOtherScaleCheck(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0x715)
end
function yume.PPTLimitCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71403001,tp,ACTIVITY_SPSUMMON)==0 end
	yume.RegPPTCostLimit(e,tp)
end
function yume.RegPPTCostLimit(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(yume.PPTCostLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function yume.PPTCostLimit(e,c)
	return not c:IsType(TYPE_PENDULUM)
end
function yume.PPTCounter()
	Duel.AddCustomActivityCounter(71403001,ACTIVITY_SPSUMMON,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM))
end
function yume.RegPPTSTGraveEffect(c,id)
	--spell & trap set from grave effect
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403001,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(yume.PPTSetFromGraveCon)
	e1:SetLabelObject(e0)
	e1:SetTarget(yume.PPTSetFromGraveTg)
	e1:SetOperation(yume.PPTSetFromGraveOp)
	c:RegisterEffect(e1)
end
function yume.PPTSetFromGraveCon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(yume.PPTFilter,1,nil,tp,se)
end
function yume.PPTFilter(c,tp,se)
	return c:IsSetCard(0x715) and c:IsControler(tp) and (se==nil or c:GetReasonEffect()~=se)
end
function yume.PPTPendFilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x715)
end
function yume.PPTSetFromGraveTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function yume.PPTSetFromGraveOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
	end
end
function yume.PPTActivateZonesLimitForPlacingPend(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	if not b or p0 and p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function yume.PPTPlacePendExceptFromFieldFilter(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function yume.RegPPTTetrisBasicMoveEffect(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403001,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCondition(yume.PPTMainPhaseCon)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(yume.PPTTetrisBasicMoveTg)
	e1:SetOperation(yume.PPTTetrisBasicMoveOp)
	c:RegisterEffect(e1)
end
function yume.RegPPTTetrisExMoveEffect(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403001,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(yume.PPTTetrisBasicMoveTg)
	e1:SetOperation(yume.PPTTetrisBasicMoveOp)
	c:RegisterEffect(e1)
end
function yume.PPTMainPhaseCon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function yume.PPTTetrisBasicMoveTg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetSequence()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function yume.PPTTetrisBasicMoveOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetSequence()<5 or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	Duel.AdjustAll()
	if c:IsLocation(LOCATION_MZONE) and c:GetSequence()==seq then
		yume.OptionalPendulum(e,c,tp)
	end
end
function yume.OptionalPendulum(e,c,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local oppo_lpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local oppo_rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local self_pend_flag = lpz ~= nil and rpz ~= nil
	local oppo_pend_flag = oppo_lpz ~= nil and oppo_rpz ~= nil
		and oppo_lpz:GetFieldID()==oppo_lpz:GetFlagEffectLabel(31531170)
		and oppo_rpz:GetFieldID()==oppo_rpz:GetFlagEffectLabel(31531170)
	if not(self_pend_flag or oppo_pend_flag) then return end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local pend_chk=aux.PendulumChecklist
	aux.PendulumChecklist=aux.PendulumChecklist&~(1<<tp)
	local eset={}
	local lscale,rscale,oppo_lscale,oppo_rscale
	local g=Duel.GetFieldGroup(tp,loc,0)
	if self_pend_flag then
		lscale=lpz:GetLeftScale()
		rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
	end
	if oppo_pend_flag then
		oppo_lscale=oppo_lpz:GetLeftScale()
		oppo_rscale=oppo_rpz:GetRightScale()
		if oppo_lscale>oppo_rscale then
			oppo_lscale,oppo_rscale=oppo_rscale,oppo_lscale
		end
	end
	self_pend_flag=self_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	oppo_pend_flag=oppo_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,oppo_lscale,oppo_rscale,eset)
	if (self_pend_flag or oppo_pend_flag) and Duel.SelectYesNo(tp,aux.Stringid(71403001,4)) then
		Duel.BreakEffect()
		--reset when special summoned
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		e1:SetLabel(pend_chk)
		e1:SetOperation(yume.ResetExtraPendulumEffect)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_NEGATED)
		e2:SetOperation(yume.ResetExtraPendulumEffect)
		e2:SetLabelObject(e1)
		e2:SetLabel(pend_chk)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
		local use_oppo_pend=not self_pend_flag or oppo_pend_flag and Duel.SelectYesNo(tp,aux.Stringid(71403001,5))
		if use_oppo_pend then
			Duel.SpecialSummonRule(tp,oppo_lpz,SUMMON_TYPE_PENDULUM)
		else
			Duel.SpecialSummonRule(tp,lpz,SUMMON_TYPE_PENDULUM)
		end
	else
		aux.PendulumChecklist=pend_chk
	end
end
function yume.ResetExtraPendulumEffect(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	aux.PendulumChecklist=e:GetLabel()
	e1:Reset()
	e:Reset()
end
function yume.RegPPTPuyopuyoBasicExtraFlag(c)
	--Destroyed and added to Extra from Main Monster Zone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(yume.RegPPTPuyopuyoBasicExtraFlagCon)
	e1:SetOperation(yume.RegPPTPuyopuyoBasicExtraFlagOp)
	c:RegisterEffect(e1)
end
function yume.RegPPTPuyopuyoBasicMoveEffect(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403001,6))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(yume.PPTPuyopuyoBasicMoveTg)
	e1:SetOperation(yume.PPTPuyopuyoBasicMoveOp)
	c:RegisterEffect(e1)
end
function yume.RegPPTPuyopuyoBasicExtraFlagCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousSequence()<5
		and c:IsReason(REASON_DESTROY) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function yume.RegPPTPuyopuyoBasicExtraFlagOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(71403019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function yume.RegPPTPuyopuyoBasicExtraCon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(71403019)>0
end
function yume.PPTPuyopuyoBasicMoveTg(e,tp,eg,ep,ev,re,r,rp,chk)
	return yume.PPTTetrisBasicMoveTg(e,tp,eg,ep,ev,re,r,rp,chk)
end
function yume.PPTPuyopuyoBasicMoveOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetSequence()<5 or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	Duel.AdjustAll()
	if not c:IsLocation(LOCATION_MZONE) or c:GetSequence()~=seq then return end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local oppo_lpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local oppo_rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local self_pend_flag = lpz ~= nil and rpz ~= nil
	local oppo_pend_flag = oppo_lpz ~= nil and oppo_rpz ~= nil
		and oppo_lpz:GetFieldID()==oppo_lpz:GetFlagEffectLabel(31531170)
		and oppo_rpz:GetFieldID()==oppo_rpz:GetFlagEffectLabel(31531170)
	local b1=loc~=0 and (self_pend_flag or oppo_pend_flag)
	local pend_chk=aux.PendulumChecklist
	if b1 then
		aux.PendulumChecklist=aux.PendulumChecklist&~(1<<tp)
		local eset={}
		local lscale,rscale,oppo_lscale,oppo_rscale
		local g=Duel.GetFieldGroup(tp,loc,0)
		if self_pend_flag then
			lscale=lpz:GetLeftScale()
			rscale=rpz:GetRightScale()
			if lscale>rscale then lscale,rscale=rscale,lscale end
		end
		if oppo_pend_flag then
			oppo_lscale=oppo_lpz:GetLeftScale()
			oppo_rscale=oppo_rpz:GetRightScale()
			if oppo_lscale>oppo_rscale then
				oppo_lscale,oppo_rscale=oppo_rscale,oppo_lscale
			end
		end
		self_pend_flag=self_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		oppo_pend_flag=oppo_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,oppo_lscale,oppo_rscale,eset)
		b1=self_pend_flag or oppo_pend_flag
	end
	local b2=c:IsRelateToEffect(e)
	local b3=true
	local options_table={}
	if b1 then table.insert(options_table,aux.Stringid(71403001,7)) end
	if b2 then table.insert(options_table,aux.Stringid(71403001,8)) end
	if b3 then table.insert(options_table,aux.Stringid(71403001,9)) end
	if not (b1 or b2) then
		aux.PendulumChecklist=pend_chk
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(options_table))
	if not b1 then op=op+1 end
	if not b2 and op==1 then op=op+1 end
	if op==0 then
		Duel.BreakEffect()
		--reset when special summoned
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		e1:SetLabel(pend_chk)
		e1:SetOperation(yume.ResetExtraPendulumEffect)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_NEGATED)
		e2:SetOperation(yume.ResetExtraPendulumEffect)
		e2:SetLabelObject(e1)
		e2:SetLabel(pend_chk)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
		local use_oppo_pend=not self_pend_flag or oppo_pend_flag and Duel.SelectYesNo(tp,aux.Stringid(71403001,5))
		if use_oppo_pend then
			Duel.SpecialSummonRule(tp,oppo_lpz,SUMMON_TYPE_PENDULUM)
		else
			Duel.SpecialSummonRule(tp,lpz,SUMMON_TYPE_PENDULUM)
		end
	else
		aux.PendulumChecklist=pend_chk
		if op==1 then
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function yume.RegPPTPuyopuyoExMoveEffect(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403022,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(yume.PPTPuyopuyoBasicMoveTg)
	e1:SetOperation(yume.PPTPuyopuyoExMoveOp)
	c:RegisterEffect(e1)
end
function yume.PPTPuyopuyoExMoveOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetSequence()<5 or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	Duel.AdjustAll()
	if not c:IsLocation(LOCATION_MZONE) or c:GetSequence()~=seq then return end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local oppo_lpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local oppo_rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	local self_pend_flag = lpz ~= nil and rpz ~= nil
	local oppo_pend_flag = oppo_lpz ~= nil and oppo_rpz ~= nil
		and oppo_lpz:GetFieldID()==oppo_lpz:GetFlagEffectLabel(31531170)
		and oppo_rpz:GetFieldID()==oppo_rpz:GetFlagEffectLabel(31531170)
	local b1=loc~=0 and (self_pend_flag or oppo_pend_flag)
	local pend_chk=aux.PendulumChecklist
	if b1 then
		aux.PendulumChecklist=aux.PendulumChecklist&~(1<<tp)
		local eset={}
		local lscale,rscale,oppo_lscale,oppo_rscale
		local g=Duel.GetFieldGroup(tp,loc,0)
		if self_pend_flag then
			lscale=lpz:GetLeftScale()
			rscale=rpz:GetRightScale()
			if lscale>rscale then lscale,rscale=rscale,lscale end
		end
		if oppo_pend_flag then
			oppo_lscale=oppo_lpz:GetLeftScale()
			oppo_rscale=oppo_rpz:GetRightScale()
			if oppo_lscale>oppo_rscale then
				oppo_lscale,oppo_rscale=oppo_rscale,oppo_lscale
			end
		end
		self_pend_flag=self_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
		oppo_pend_flag=oppo_pend_flag and g:IsExists(aux.PConditionFilter,1,nil,e,tp,oppo_lscale,oppo_rscale,eset)
		b1=self_pend_flag or oppo_pend_flag
	end
	local desg=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b2=desg:GetCount()>0
	local b3=true
	local options_table={}
	if b1 then table.insert(options_table,aux.Stringid(71403022,2)) end
	if b2 then table.insert(options_table,aux.Stringid(71403022,3)) end
	if b3 then table.insert(options_table,aux.Stringid(71403022,4)) end
	if not (b1 or b2) then
		aux.PendulumChecklist=pend_chk
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(options_table))
	if not b1 then op=op+1 end
	if not b2 and op==1 then op=op+1 end
	if op==0 then
		Duel.BreakEffect()
		--reset when special summoned
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		e1:SetLabel(pend_chk)
		e1:SetOperation(yume.ResetExtraPendulumEffect)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_NEGATED)
		e2:SetOperation(yume.ResetExtraPendulumEffect)
		e2:SetLabelObject(e1)
		e2:SetLabel(pend_chk)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
		local use_oppo_pend=not self_pend_flag or oppo_pend_flag and Duel.SelectYesNo(tp,aux.Stringid(71403001,5))
		if use_oppo_pend then
			Duel.SpecialSummonRule(tp,oppo_lpz,SUMMON_TYPE_PENDULUM)
		else
			Duel.SpecialSummonRule(tp,lpz,SUMMON_TYPE_PENDULUM)
		end
	else
		aux.PendulumChecklist=pend_chk
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=desg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end