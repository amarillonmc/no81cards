--谐谑之宇宙姬
local s,id,o=GetID()
function s.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1101)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
		--special summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1118)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetCode(EVENT_DESTROYED)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCountLimit(1,id+1)
		e2:SetCondition(s.spcon)
		e2:SetTarget(s.sptg)
		e2:SetOperation(s.spop)
		e2:SetLabelObject(e1)
		c:RegisterEffect(e2)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,TYPE_MONSTER) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function s.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck1(tp,sg,fc)
	return #sg<=3
end
function s.gcheck1(sg)
	return #sg<=3
end
function s.fcheck2(tp,sg,fc)
	return #sg<=6
end
function s.gcheck2(sg)
	return #sg<=6
end
function s.fcheck3(tp,sg,fc)
	return #sg<=9
end
function s.gcheck3(sg)
	return #sg<=9
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,3,nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	local og=Duel.GetOperatedGroup()
	if #og==0 then return end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE,0,nil,e)
	if #og==1 then
		aux.FCheckAdditional=s.fcheck1
		aux.GCheckAdditional=s.gcheck1
	elseif #og==2 then
		aux.FCheckAdditional=s.fcheck2
		aux.GCheckAdditional=s.gcheck2
	elseif #og==3 then
		aux.FCheckAdditional=s.fcheck3
		aux.GCheckAdditional=s.gcheck3
	end
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e:GetLabelObject()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end