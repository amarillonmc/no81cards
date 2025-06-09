--月咏小萌
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	--extra summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(s.sumop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(2)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	c:RegisterEffect(e4)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsPlayerCanSummon(tp) or Duel.IsPlayerCanAdditionalSummon(tp)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	--e1:SetTargetRange(1,0)
	e1:SetTarget(s.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.estg(e,c)
	--return c.MoJin==true
	return not c:IsSetCard(0x23333a)
end
function s.val(e,c)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetFlagEffect(tp,id)
	return ct+1
end
function s.mfilter1(c)
	return c.MoJin==true and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.mfilter2(c)
	return c.MoJin==true and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.sfselect(g,tp)
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.xfselect(g,tp)
	return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.lfselect(g,tp)
	return Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.chkfilter(c,e,tp,m,f,chkf)
	if not c.MoJin==true then return end
	return s.ffilter(c,e,tp,m,f,chkf) or c:IsSynchroSummonable(nil,m) or c:IsXyzSummonable(m) or c:IsLinkSummonable(m,nil)
end
function s.ffilter(c,e,tp,m,f,chkf)
	return c.MoJin==true and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.chksfilter(c,g)
	return c:IsSynchroSummonable(nil,g) 
end
function s.chkxfilter(c,g)
	return c:IsXyzSummonable(g)
end
function s.chklfilter(c,g)
	return c:IsLinkSummonable(g,nil)
end
function s.synfilter(c,g)
	return c.MoJin==true and c:IsSynchroSummonable(nil,g,#g-1,#g-1)
end
function s.xyzfilter(c,g)
	return c.MoJin==true and c:IsXyzSummonable(g,#g,#g)
end
function s.lfilter(c,g)
	return c.MoJin==true and c:IsLinkSummonable(g,nil,#g,#g)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	local exg=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,c)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then 
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_CHAIN,0,1)
		sg:Merge(exg) 
	end
	local res=Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	local b1=res
	local b2=sg:CheckSubGroup(s.sfselect,1,#sg,tp)
	local b3=sg:CheckSubGroup(s.xfselect,1,#sg,tp)
	local b4=sg:CheckSubGroup(s.lfselect,1,#sg,tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	local ckg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg,nil,chkf)
	if #ckg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
	local chkccc=ckg:Select(tp,1,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end	
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local c=e:GetHandler()
	local sel=e:GetLabel()
	local sg=Duel.GetMatchingGroup(s.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	local exg=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,c)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(tp,id)>0 then 
		sg:Merge(exg) 
	end
	if sel==1 then
		local mg1=sg:Filter(s.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local chkccc=sg1:Select(tp,1,1,nil)
			local fsg=sg1:Clone()
			if sg2 then fsg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=fsg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				local tg=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)
				local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				Duel.SendtoGrave(tg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	elseif sel==2 then
		local schk=Duel.GetMatchingGroup(s.chksfilter,tp,LOCATION_EXTRA,0,nil,sg)
		if #schk==0 then return end 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local chkccc=schk:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,512)
		local syg=sg:SelectSubGroup(tp,s.sfselect,false,1,#sg,tp)
		local syng=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,syg)
		if #syng>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=syng:Select(tp,1,1,nil):GetFirst()
			tc:SetMaterial(syg)
			local tg=syg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)
			local rg=syg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			Duel.SendtoGrave(tg,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	elseif sel==3 then
		local xchk=Duel.GetMatchingGroup(s.chkxfilter,tp,LOCATION_EXTRA,0,nil,sg)
		if #xchk==0 then return end 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local chkccc=xchk:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,513)
		local syg=sg:SelectSubGroup(tp,s.xfselect,false,1,#sg,tp)
		local syng=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,syg)
		if #syng>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=syng:Select(tp,1,1,nil):GetFirst()
			tc:SetMaterial(syg)
			for sc in aux.Next(syg) do
				local mg=sc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(tc,mg)
				end
			end
			Duel.Overlay(tc,syg)
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		local lchk=Duel.GetMatchingGroup(s.chklfilter,tp,LOCATION_EXTRA,0,nil,sg)
		if #lchk==0 then return end 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local chkccc=lchk:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,533)
		local syg=sg:SelectSubGroup(tp,s.lfselect,false,1,#sg,tp)
		local syng=Duel.GetMatchingGroup(s.lfilter,tp,LOCATION_EXTRA,0,nil,syg)
		if #syng>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=syng:Select(tp,1,1,nil):GetFirst()
			tc:SetMaterial(syg)
			local tg=syg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)
			local rg=syg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			Duel.SendtoGrave(tg,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end