--破碎世界 虚空之梦
function c6160504.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,6160504)  
	e1:SetTarget(c6160504.target)  
	e1:SetOperation(c6160504.activate)  
	c:RegisterEffect(e1)  
	 --protection  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160504,1))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(aux.bfgcost) 
	e2:SetCountLimit(1,6160504) 
	e2:SetOperation(c6160504.operation)  
	c:RegisterEffect(e2) 
end  
function c6160504.filter0(c)  
	return (c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()  
end  
function c6160504.filter1(c,e)  
	return (c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)  
end  
function c6160504.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x616) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function c6160504.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg=Duel.GetMatchingGroup(c6160504.filter0,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)  
		local res=Duel.IsExistingMatchingCard(c6160504.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg3=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(c6160504.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_REMOVED)  
end  
function c6160504.activate(e,tp,eg,ep,ev,re,r,rp)  
	local chkf=tp  
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c6160504.filter1),tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,nil,e)  
	local sg1=Duel.GetMatchingGroup(c6160504.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)  
	local mg3=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg3=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(c6160504.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)  
	end  
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)  
			tc:SetMaterial(mat)  
			if mat:IsExists(Card.IsFacedown,1,nil) then  
				local cg=mat:Filter(Card.IsFacedown,nil)  
				Duel.ConfirmCards(1-tp,cg)  
			end  
			Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  
function c6160504.operation(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(c6160504.efftg)  
	e1:SetValue(aux.tgoval)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function c6160504.efftg(e,c)  
	return c:IsSetCard(0x616)  
end  