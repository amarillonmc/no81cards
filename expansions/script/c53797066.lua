local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttackBelow,1000),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.chcon)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	s[0]=false
	local rc=re:GetHandler()
	if rc:IsOnField() and rc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) then rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ev) end
	local atk=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTACK)
	return ep==tp and re:IsActiveType(TYPE_MONSTER) and atk>rc:GetBaseAttack() and Duel.GetCurrentPhase()==PHASE_END
end
function s.fcheck(atk)
	return  function(tp,sg,fc)
				return sg:GetSum(Card.GetAttack)==atk
			end
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:GetOriginalCode()==id and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	if s[0] then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp,LOCATION_HAND):Filter(s.filter1,nil,re)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	mg1=mg1:Filter(Card.IsCode,nil,table.unpack{re:GetHandler():GetCode()})
	local atk=re:GetHandler():GetAttack()
	aux.FCheckAdditional=s.fcheck(atk)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,re,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,re,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,re,tp,mg3,mf,chkf)
	end
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,s.fsop)
	end
	aux.FCheckAdditional=nil
	s[0]=true
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp,LOCATION_HAND):Filter(s.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	mg1=mg1:Filter(Card.IsCode,nil,table.unpack{e:GetHandler():GetCode()})
	local atk=e:GetHandler():GetAttack()
	aux.FCheckAdditional=s.fcheck(atk)
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
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) then
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
	aux.FCheckAdditional=nil
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	if not se or not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) or not se:IsActiveType(TYPE_MONSTER) then return false end
	local res
	for _,v in ipairs({se:GetHandler():GetFlagEffectLabel(id)}) do if v==Duel.GetCurrentChain() then res=true end end
	return (not se:IsActivated() and se:GetHandler():IsOnField()) or res
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT):GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(sc)
	e1:SetOperation(s.adjustop)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2,true)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetAttack()
	if c:GetFlagEffect(id+500)==0 then c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1,atk) end
	if atk==c:GetFlagEffectLabel(id+500)/2 then Duel.RaiseEvent(c,EVENT_CUSTOM+id,e,0,0,0,0) end
	c:SetFlagEffectLabel(id+500,atk)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<=1000
end
