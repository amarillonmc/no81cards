--梦中之丝绸蚕
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.quickcon)
	e2:SetTarget(s.qtg)
	e2:SetOperation(s.qop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetLabel(id)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.cfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.GetMZoneCount(tp,c)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(tp,s.cfilter,1,REASON_SPSUMMON,true,c,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON):Filter(s.cfilter,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function s.quickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and e:GetHandler():GetFlagEffect(id)>0
end
function s.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_INSECT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function s.qtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	local c=e:GetHandler()
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_MZONE,nil)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
	end
	local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
		end
	end
	local b1=Duel.IsPlayerCanDiscardDeck(tp,4) and (Duel.GetFlagEffect(tp,id+o*2)==0 or not e:IsCostChecked())
	local b2=res and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and not b2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,1191)
		op=1
	end
	if b2 and not b1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,1169)
		op=2
	end
	if b1 and b2 then
		op=aux.SelectFromOptions(tp,{b1,1191},{b2,1169})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		end
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.qop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	if opt==1 then
		local g=Duel.GetDecktopGroup(tp,4)
		if #g<4 then return end
		Duel.DisableShuffleCheck()
		if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(function(c) return c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_INSECT) end,nil)
		if ct>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	elseif opt==2 then
		local chkf=tp
		if Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)~=0 then return end
		if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(s.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_MZONE,nil):Filter(s.filter1,nil,e)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
		end
		local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,c,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,c,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end