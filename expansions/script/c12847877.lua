--自奏圣乐·通天之音
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.mfilter,2,true)
	--extra fusion
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.con0)
	e0:SetOperation(s.op0)
	e0:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(s.subcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(s.spcon2)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return c:IsFusionType(TYPE_MONSTER)
end
function s.MgFilter(sg,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.MgFilter,2,2,tp,c)
end
function s.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,s.MgFilter,false,2,2,tp,c)
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		if tc:IsFacedown() then tg:AddCard(tc) end
	end
	if tg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x3b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.red_eyes_fusion_check or s.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function s.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x3b)
end
function s.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter4(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_HAND)
end
function s.filter5(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0xc008) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck2(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0xc008)
end
function s.filter6(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter7(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter8(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.branded_fusion_check or s.fcheck3
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function s.fcheck3(tp,sg,fc)
	return sg:GetCount()<=2 and sg:IsExists(Card.IsFusionCode,1,nil,68468459)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4))
		if op==0 then
		local token=Duel.CreateToken(tp,06172122)
		Duel.SendtoGrave(token,REASON_RULE)
		if token:IsLocation(LOCATION_GRAVE) then
		local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,6)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=tc.red_eyes_fusion_check or s.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(74677422)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		end
		aux.FCheckAdditional=nil
	end
		elseif op==1 then
		local token=Duel.CreateToken(tp,52947044)
		Duel.SendtoGrave(token,REASON_RULE)
		if token:IsLocation(LOCATION_GRAVE) then
		local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter4,nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=s.fcheck2
	local sg1=Duel.GetMatchingGroup(s.filter5,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter5,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,6)) then return end
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(s.descon)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	aux.FCheckAdditional=nil
	end
		elseif op==2 then
		local token=Duel.CreateToken(tp,44362883)
		Duel.SendtoGrave(token,REASON_RULE)
		if token:IsLocation(LOCATION_GRAVE) then
		local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter7,nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter6,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(s.filter8,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter8,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		if not Duel.SelectYesNo(tp,aux.Stringid(id,6)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=tc.branded_fusion_check or s.fcheck3
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function s.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not aux.IsCanBeQuickEffect(e:GetHandler(),tp,90351981) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1 
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsCanBeQuickEffect(e:GetHandler(),tp,90351981)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end