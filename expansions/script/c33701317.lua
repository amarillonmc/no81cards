--卓越融合
function c33701317.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33701317.target)
	e1:SetOperation(c33701317.activate)
	c:RegisterEffect(e1)
end
function c33701317.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c33701317.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c33701317.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c33701317.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c33701317.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c33701317.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c33701317.filter3,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_DECK+LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c33701317.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c33701317.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c33701317.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c33701317.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c33701317.filter3,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_DECK+LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c33701317.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c33701317.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			--
			local zc=mat1:GetFirst()
			local x=0
			while zc do 
			if zc:IsLocation(LOCATION_GRAVE) then		   
			x=x+1500
			elseif zc:IsLocation(LOCATION_DECK) and zc:IsControler(tp) then
			x=x+4000
			elseif zc:IsLocation(LOCATION_DECK) and zc:IsControler(tp) then
			x=x+6000	   
			end
			zc=mat1:GetNext()
			end
			e:SetLabel(x)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()	  
		Duel.SetLP(tp,Duel.GetLP(tp)-e:GetLabel())
	end
end
	

