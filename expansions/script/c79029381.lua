--炎·岁·部署-六界降临
function c79029381.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,79029381+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79029381.target)
	e1:SetOperation(c79029381.activate)
	c:RegisterEffect(e1)
end
function c79029381.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c79029381.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c79029381.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xa900) and c:IsAttribute(ATTRIBUTE_DIVINE) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c79029381.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c79029381.lkfil1(c,e,tp)
	local lv=c:GetLink()
	local rg=Duel.GetMatchingGroup(c79029381.lkfil2,tp,LOCATION_REMOVED,0,nil)
	return c:IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and rg:GetCount()>=lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:IsSetCard(0xa900) and c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c79029381.lkfil2(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900)
end
function c79029381.target(e,tp,eg,ep,ev,re,r,rp,chk)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c79029381.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c79029381.filter3,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c79029381.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c79029381.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
	local lks=Duel.IsExistingMatchingCard(c79029381.lkfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return res or lks end
	local op=0
	if res and lks then
	op=Duel.SelectOption(tp,aux.Stringid(79029381,0),aux.Stringid(79029381,1))
	elseif res then
	op=Duel.SelectOption(tp,aux.Stringid(79029381,0))   
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029381,1))+1
	end
	e:SetLabel(op)
	if op==0 then 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_DECK)
	else
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c79029381.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c79029381.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c79029381.filter3,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c79029381.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c79029381.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
		if tc:IsCode(79029382) then
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,2))
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,3))
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,4))
		end
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79029381.lkfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local lv=tc:GetLink()
		local rg=Duel.GetMatchingGroup(c79029381.lkfil2,tp,LOCATION_REMOVED,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g3=rg:Select(tp,lv,lv,nil)
		Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
		if tc:IsCode(79029383) then
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,5))
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,6))
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029381,7))
		end
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)  
   end
end





