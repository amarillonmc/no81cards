--石鬼面
function c9980509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9980509.target)
	e1:SetOperation(c9980509.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(9980509,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9980509)
	e2:SetTarget(c9980509.tdtg)
	e2:SetOperation(c9980509.tdop)
	c:RegisterEffect(e2)
end
function c9980509.filter0(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToRemove()
end
function c9980509.filter1(c,e)
	return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c9980509.filter2(c,e,tp,m,f,chkf)
	return ((c:IsType(TYPE_FUSION) and c:IsLevelAbove(8) and (c:IsRace(RACE_ROCK) or c:IsRace(RACE_ZOMBIE))) or c:IsCode(9980505))and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x5bcc,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9980509.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c9980509.filter4(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c9980509.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c9980509.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c9980509.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 then
			mg1:Merge(Duel.GetMatchingGroup(c9980509.filter4,tp,LOCATION_PZONE,0,nil,e))
		end
		local res=Duel.IsExistingMatchingCard(c9980509.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9980509.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980509.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9980509.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c9980509.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2 then
		mg1:Merge(Duel.GetMatchingGroup(c9980509.filter4,tp,LOCATION_PZONE,0,nil,e))
	end
	local sg1=Duel.GetMatchingGroup(c9980509.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9980509.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+0x5bcc,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2,SUMMON_TYPE_FUSION+0x5bcc)
		end
		tc:CompleteProcedure()
	end
end
function c9980509.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980509.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end