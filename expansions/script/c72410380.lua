--日月融合
function c72410380.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410380,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72410380+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c72410380.target)
	e1:SetOperation(c72410380.activate)
	c:RegisterEffect(e1)
end

function c72410380.filter0(c)
	return c:IsOnField() and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function c72410380.filter1(c,e)
	return c:IsOnField() and (c:IsAbleToDeck() or c:IsAbleToExtra()) and not c:IsImmuneToEffect(e)
end
function c72410380.filter3(c,e)
	return c:IsAbleToGrave() and c:IsCanBeFusionMaterial()
end
function c72410380.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION)  and (not f or f(c)) and (aux.IsMaterialListCode(c,72410390) or aux.IsMaterialListCode(c,72410400))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.sun_and_moon_fusion_check or c72410380.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function c72410380.filter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function c72410380.fcheck(tp,sg,fc)
	return (sg:IsExists(Card.IsFusionCode,1,nil,72410400) or sg:IsExists(Card.IsFusionCode,1,nil,72410390)) and sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end

function c72410380.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end
function c72410380.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c72410380.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c72410380.filter4,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local mg0=Duel.GetMatchingGroup(c72410380.filter3,tp,LOCATION_EXTRA,0,nil)
			if mg0:GetCount()>0 then
				mg1:Merge(mg0)
				Auxiliary.FCheckAdditional=c72410380.fcheck
				Auxiliary.GCheckAdditional=c72410380.gcheck
			end
		local res=Duel.IsExistingMatchingCard(c72410380.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c72410380.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		e:SetLabel(res)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c72410380.activate(e,tp,eg,ep,ev,re,r,rp)

	local res=e:GetLabel(res)
	local chkf=tp
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c72410380.filter0,nil)
	local mg2=Duel.GetMatchingGroup(c72410380.filter4,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local exmat=false
	local mg0=Duel.GetMatchingGroup(c72410380.filter3,tp,LOCATION_EXTRA,0,nil)
		if mg0:GetCount()>0 then
			mg1:Merge(mg0)
			exmat=true
		end
	if exmat then
		Auxiliary.FCheckAdditional=c72410380.fcheck
		Auxiliary.GCheckAdditional=c72410380.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c72410380.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c72410380.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=tc.sun_and_moon_fusion_check or c72410380.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc)) then
		   if exmat then
				Auxiliary.FCheckAdditional=c72410380.fcheck
				Auxiliary.GCheckAdditional=c72410380.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
				local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			mat1:Remove(Card.IsLocation,nil,LOCATION_EXTRA)
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end