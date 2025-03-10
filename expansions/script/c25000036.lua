--核成兽的融核
function c25000036.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--aux.EnableChangeCode(c,36623431,LOCATION_HAND+LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,25000036+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c25000036.target)
	e1:SetOperation(c25000036.activate)
	c:RegisterEffect(e1)
end
function c25000036.filter0(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove()
end
function c25000036.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c25000036.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1d) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c25000036.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c25000036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c25000036.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c25000036.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c25000036.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c25000036.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c25000036.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c25000036.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c25000036.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c25000036.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c25000036.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			if mat1:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==#mat1 then
				check=true
			end
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2,SUMMON_TYPE_FUSION)
		end
		tc:CompleteProcedure()
	end
	local g=Duel.GetMatchingGroup(c25000036.thfilter,tp,LOCATION_DECK,0,nil)
	if check and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(25000036,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:SelectSubGroup(tp,c25000036.gcheck,false,1,2)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c25000036.thfilter(c)
	return c:IsSetCard(0x1d) and (c:IsSummonableCard() or c:IsCode(36623431)) and c:IsAbleToHand()
end
function c25000036.gcheck(sg)
	return sg:FilterCount(Card.IsCode,nil,36623431)<=1 and sg:FilterCount(Card.IsSummonableCard,nil)<=1
end
