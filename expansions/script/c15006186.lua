local m=15006186
local cm=_G["c"..m]
cm.name="巡星兽 胚"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200)
	--fusion summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.fstg)
	e0:SetOperation(cm.fsop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.sp2con)
	e2:SetCost(cm.sp2cost)
	e2:SetTarget(cm.sp2tg)
	e2:SetOperation(cm.sp2op)
	c:RegisterEffect(e2)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9f44) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.sp2filter(c,e,tp)
	return c:IsCode(15006200) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sp2filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e2:SetCost(cm.cost)
		e2:SetTarget(cm.target)
		e2:SetOperation(cm.operation)
		tc:RegisterEffect(e2)
		--change type
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetCode(EFFECT_ADD_TYPE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetValue(TYPE_EFFECT)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		--
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function cm.excostfilter(c,tp)
	return c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local locs=0
	local loco=0
	if Duel.IsPlayerAffectedByEffect(tp,15006207) then locs=LOCATION_HAND+LOCATION_MZONE end
	if Duel.IsPlayerAffectedByEffect(tp,15006206) then loco=LOCATION_MZONE end
	local ag=Group.CreateGroup()
	if c:IsReleasable() then ag:AddCard(c) end
	local arg=Duel.GetMatchingGroup(cm.excostfilter,tp,locs,loco,nil,tp)
	if #arg>0 then ag:Merge(arg) end
	if chk==0 then return #ag>0 end
	local rc=c
	if #ag>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		rc=ag:Select(tp,1,1,nil):GetFirst()
	end
	if rc:IsControler(1-tp) then
		Duel.HintSelection(Group.FromCards(rc))
		local te=Duel.IsPlayerAffectedByEffect(tp,15006206)
		te:UseCountLimit(tp)
	end
	if rc~=c then Duel.Hint(HINT_CARD,1-tp,15006206) end
	Duel.Release(rc,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsSetCard(0x9f44) and dc:IsAbleToGrave() and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.SendtoGrave(dc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end