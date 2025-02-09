--天魔之融合使 阿尔缇娜
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
	if rc:IsLocation(LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
	if rc:IsLocation(LOCATION_ONFIELD) then
		Duel.RegisterFlagEffect(rp,id+2,RESET_PHASE+PHASE_END,0,1)
	end
	if rc:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(rp,id+3,RESET_PHASE+PHASE_END,0,1)
	end
	if rc:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(rp,id+4,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.filter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsFaceup()
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck(tp,sg,fc)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function s.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Group.CreateGroup()
		local mg3=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_HAND,0,c)
		if #mg3>0 and Duel.GetFlagEffect(1-tp,id)>0 then 
			mg1:Merge(mg3)
		end
		local mg4=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
		if #mg4>0 and Duel.GetFlagEffect(1-tp,id+1)>0 then
			mg1:Merge(mg4)
		end
		local mg5=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE,0,nil)
		if #mg5>0 and Duel.GetFlagEffect(1-tp,id+2)>0 then 
			mg1:Merge(mg5)
		end
		local mg6=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,nil)
		if #mg6>0 and Duel.GetFlagEffect(1-tp,id+3)>0 then
			mg1:Merge(mg6)
		end
		local mg7=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_REMOVED,0,nil)
		if #mg7>0 and Duel.GetFlagEffect(1-tp,id+4)>0 then 
			mg1:Merge(mg7)
		end
		if not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:IsCanBeFusionMaterial()
		and c:IsAbleToRemove() and Duel.GetFlagEffect(1-tp,id+3)>0 then 
			mg1:AddCard(c)
		end
		if c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:IsCanBeFusionMaterial()
		and c:IsAbleToDeck() and Duel.GetFlagEffect(1-tp,id+4)>0 then 
			mg1:AddCard(c)
		end
		Auxiliary.FCheckAdditional=s.fcheck
		Auxiliary.GCheckAdditional=s.gcheck
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Group.CreateGroup()
	local mg3=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_HAND,0,c)
	if #mg3>0 and Duel.GetFlagEffect(1-tp,id)>0 then 
		mg1:Merge(mg3)
	end
	local mg4=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	if #mg4>0 and Duel.GetFlagEffect(1-tp,id+1)>0 then 
		mg1:Merge(mg4)
	end
	local mg5=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,0,nil,e)
	if #mg5>0 and Duel.GetFlagEffect(1-tp,id+2)>0 then 
		mg1:Merge(mg5)
	end
	local mg6=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,nil)
	if #mg6>0 and Duel.GetFlagEffect(1-tp,id+3)>0 then 
		mg1:Merge(mg6)
	end
	local mg7=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_REMOVED,0,nil)
	if #mg7>0 and Duel.GetFlagEffect(1-tp,id+4)>0 then 
		mg1:Merge(mg7)
	end
	Auxiliary.FCheckAdditional=s.fcheck
	Auxiliary.GCheckAdditional=s.gcheck
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Auxiliary.FCheckAdditional=s.fcheck
			Auxiliary.GCheckAdditional=s.gcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local gmat=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
			local rmat=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			local dmat=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if #gmat>0 then Duel.SendtoGrave(gmat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			if #rmat>0 then Duel.Remove(rmat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
			if #dmat>0 then Duel.SendtoDeck(dmat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
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