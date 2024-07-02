--救世神龙 传承琉迩
function c75000003.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2FunRep(c,21159309,75000001,aux.FilterBoolFunction(Card.IsFusionSetCard,0x751),1,1,true,true)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(function(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(function(e,ep,tp) return tp==ep end) end) 
	e2:SetCondition(function(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e2) 
	--atk 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetAttribute)*500 end) 
	c:RegisterEffect(e3) 
	--to deck and dam 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,75000003) 
	e4:SetCost(c75000003.tddcost)
	e4:SetTarget(c75000003.tddtg) 
	e4:SetOperation(c75000003.tddop) 
	c:RegisterEffect(e4) 
	--fusion 
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD) 
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(1,15000003)
	e5:SetCondition(function(e) 
	return e:GetHandler():GetReasonPlayer()==1-e:GetHandlerPlayer() end)
	e5:SetTarget(c75000003.futg)
	e5:SetOperation(c75000003.fuop)
	c:RegisterEffect(e5)
end
c75000003.material_setcode=75000001   
function c75000003.tddcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x751) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() end,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0x751) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() end,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST) 
end 
function c75000003.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,1-tp,LOCATION_GRAVE+LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end 
function c75000003.tddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then 
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		g:Merge(g1)
	end 
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) then 
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
		g:Merge(g2)
	end  
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then 
		Duel.Damage(1-tp,600,REASON_EFFECT)
		Duel.Damage(1-tp,600,REASON_EFFECT)
	end 
end 
function c75000003.filter0(c)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c75000003.filter1(c,e)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c75000003.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (aux.IsMaterialListCode(c,75000001) or aux.IsMaterialListSetCard(c,75000001)) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c75000003.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c75000003.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c75000003.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c75000003.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c75000003.fuop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75000003.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c75000003.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c75000003.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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








