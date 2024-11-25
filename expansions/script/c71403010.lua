--存块！旋转！
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403014,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c71403010.tg1)
	e1:SetOperation(c71403010.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403010)
	yume.PPTCounter()
end
function c71403010.filter1(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c71403010.filter1a1(c)
	--Whether being able to place in p zone or go to grave is not checked for there is no effect forbidding player to send cards to grave from extra deck.
	return c71403010.filter1(c) and c:IsAbleToExtra()
end
function c71403010.filter1b1(c)
	return c71403010.filter1(c) and c:IsCanChangePosition()
end
function c71403010.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local op=e:GetLabel()
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and
			(op==0 and c71403010.filter1a1(chkc) or op==1 and c71403010.filter1b1(chkc))
	end
	local b1=Duel.IsExistingTarget(c71403010.filter1a1,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingTarget(c71403010.filter1b1,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71403014,1),aux.Stringid(71403014,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71403014,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71403014,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local tg=Duel.SelectTarget(tp,c71403010.filter1a1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,tg,tg:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tg=Duel.SelectTarget(tp,c71403010.filter1b1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,tg:GetCount(),0,0)
	end
end
function c71403010.filter1a2(c,p_zone_check)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and (p_zone_check and not c:IsForbidden() or c:IsAbleToGrave())
end
function c71403010.filter1b2(c,p_zone_check)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
	and (p_zone_check and not c:IsForbidden() or c:IsAbleToHand())
end
function c71403010.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local op1=e:GetLabel()
	local c=e:GetHandler()
	local p_zone_check=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if op1==0 then
		if Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local og=Duel.SelectMatchingCard(tp,c71403010.filter1a2,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,p_zone_check)
			if og:GetCount()==0 then return end
			local oc=og:GetFirst()
			local op2=0
			p_zone_check=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
			if p_zone_check and oc:IsAbleToGrave() then
				op2=Duel.SelectOption(tp,aux.Stringid(71403010,3),aux.Stringid(71403010,4))
			elseif p_zone_check then
				op2=Duel.SelectOption(tp,aux.Stringid(71403010,3))
			else
				op2=Duel.SelectOption(tp,aux.Stringid(71403010,4))+1
			end
			Duel.BreakEffect()
			local op_ct=false
			if op2==0 then
				op_ct=Duel.MoveToField(oc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else
				op_ct=Duel.SendtoGrave(oc,REASON_EFFECT)>0 and oc:IsLocation(LOCATION_GRAVE)
			end
			if op_ct then
				c71403010.OptionalPendulum(e,c,tp,tc)
			end
		end
	else
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71403010.filter1b2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,p_zone_check)
			if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71403010,5)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local oc=mg:Select(tp,1,1,nil):GetFirst()
				local op2=0
				p_zone_check=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
				if p_zone_check and oc:IsAbleToGrave() then
					op2=Duel.SelectOption(tp,aux.Stringid(71403010,6),aux.Stringid(71403010,3))
				elseif p_zone_check then
					op2=Duel.SelectOption(tp,aux.Stringid(71403010,6))
				else
					op2=Duel.SelectOption(tp,aux.Stringid(71403010,3))+1
				end
				Duel.BreakEffect()
				if op2==0 then
					Duel.SendtoHand(oc,nil,REASON_EFFECT)
				else
					Duel.MoveToField(oc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				end
			end
		end
	end
end
function c71403010.OptionalPendulum(e,c,tp,exc)
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
	--temp special summon limit
	local exc_e1=Effect.CreateEffect(c)
	exc_e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	exc_e1:SetType(EFFECT_TYPE_SINGLE)
	exc_e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	exc_e1:SetReset(RESET_CHAIN)
	exc_e1:SetValue(aux.FALSE)
	exc:RegisterEffect(exc_e1)
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
		exc_e1:Reset()
	end
end