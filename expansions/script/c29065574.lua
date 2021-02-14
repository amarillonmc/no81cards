--怒号光明
function c29065574.initial_effect(c)
	aux.AddCodeList(c,29065577)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065574,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,29065574+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c29065574.cost)
	e1:SetTarget(c29065574.target)
	e1:SetOperation(c29065574.activate)
	c:RegisterEffect(e1)	
  
end
function c29065574.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c29065574.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c29065574.mxfil(c)
	return (c:IsCode(29065577) or (c:IsSetCard(0x87af) and c:IsRace(RACE_DRAGON))) and c:IsAbleToRemove()
end
function c29065574.nxfil(c)
	return c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_GRAVE)
end
function c29065574.filter(c,e,tp,m,f,chkf)
if c:IsSetCard(0x87af) then
 m4=Duel.GetMatchingGroup(c29065574.mxfil,tp,LOCATION_DECK,0,nil)
 m:Merge(m4)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0x87af)   
else
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m:Filter(c29065574.nxfil,nil),nil,chkf)
end
end
function c29065574.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c29065574.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c29065574.xyzfil(c,e,tp)
	local att=c:GetAttribute()
	local rc=c:GetRace()
	return c:IsSetCard(0x87af) and Duel.IsExistingMatchingCard(c29065574.xzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,att,rc) and c:IsLevelBelow(6)
end
function c29065574.xzfil(c,e,tp,mc,att,rc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRace(rc) and c:IsAttribute(att) and c:IsRank(8) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c29065574.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c29065574.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c29065574.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c29065574.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c29065574.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c29065574.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		Auxiliary.FCheckAdditional=c29065574.fcheck
		local res=Duel.IsExistingMatchingCard(c29065574.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c29065574.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		Auxiliary.FCheckAdditional=nil
	local xg=Duel.GetMatchingGroup(c29065574.xyzfil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(c29065574.cfilter,tp,0,LOCATION_MZONE,1,nil) then
	local xxg=Duel.GetMatchingGroup(c29065574.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	xg:Merge(xxg)
	end
	local xyz=xg:GetCount()>0
	if chk==0 then return res or xyz end
	local op=0 
	if res and xyz then
	op=Duel.SelectOption(tp,aux.Stringid(29065574,0),aux.Stringid(29065574,1))
	elseif res then
	op=Duel.SelectOption(tp,aux.Stringid(29065574,0))
	elseif xyz then 
	op=Duel.SelectOption(tp,aux.Stringid(29065574,1))+1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29065574.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c29065574.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c29065574.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
	Auxiliary.FCheckAdditional=c29065574.fcheck
	local sg1=Duel.GetMatchingGroup(c29065574.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c29065574.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
	   if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
	 if tc:IsSetCard(0x87af) then
			mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
	 else
	 mat1=Duel.SelectFusionMaterial(tp,tc,mg1:Filter(c29065574.nxfil,nil),nil,chkf)
	 end
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	   tc:RegisterFlagEffect(29065574,RESET_EVENT+RESETS_STANDARD,0,1)		 
	   local e2=Effect.CreateEffect(e:GetHandler())		
	   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)		
	   e2:SetCode(EVENT_PHASE+PHASE_END)	   
	   e2:SetCountLimit(1)		 
	   e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	   
	   e2:SetLabel(Duel.GetTurnCount()+1)	  
	   e2:SetLabelObject(tc)	   
	   e2:SetReset(RESET_PHASE+PHASE_END,2)		
	   e2:SetCondition(c29065574.rmcon)		
	   e2:SetOperation(c29065574.rmop)		 
	   Duel.RegisterEffect(e2,tp)
	end
	Auxiliary.FCheckAdditional=nil
	else
	local xg=Duel.GetMatchingGroup(c29065574.xyzfil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(c29065574.cfilter,tp,0,LOCATION_MZONE,1,nil) then
	local xxg=Duel.GetMatchingGroup(c29065574.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	xg:Merge(xxg)
	end
	if xg:GetCount()>0 then
	local tc=xg:Select(tp,1,1,nil):GetFirst()
	local rc=tc:GetRace()
	local att=tc:GetAttribute()
	local xc=Duel.SelectMatchingCard(tp,c29065574.xzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,att,rc):GetFirst()
	Duel.SpecialSummonStep(xc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	Duel.Overlay(xc,tc)
	e:GetHandler():CancelToGrave()
	Duel.Overlay(xc,e:GetHandler())
	Duel.SpecialSummonComplete()
	xc:CompleteProcedure()
	xc:RegisterFlagEffect(29065574,RESET_EVENT+RESETS_STANDARD,0,1)		 
	local e2=Effect.CreateEffect(e:GetHandler())		
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)		
	e2:SetCode(EVENT_PHASE+PHASE_END)	   
	e2:SetCountLimit(1)		 
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	   
	e2:SetLabel(Duel.GetTurnCount()+1)	  
	e2:SetLabelObject(xc)	   
	e2:SetReset(RESET_PHASE+PHASE_END,2)		
	e2:SetCondition(c29065574.rmcon)		
	e2:SetOperation(c29065574.rmop)		 
	Duel.RegisterEffect(e2,tp)
	end
  end
end
function c29065574.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(29065574)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c29065574.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end