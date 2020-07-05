local m=82206030
local cm=_G["c"..m]
cm.name="植占师10-寒冰"
function cm.initial_effect(c)
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_NEGATE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e1:SetCondition(cm.negcon)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.negcost)  
	e1:SetTarget(cm.negtg)  
	e1:SetOperation(cm.negop)  
	c:RegisterEffect(e1) 
	--spsummon  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,82216030)  
	e2:SetTarget(cm.futg)  
	e2:SetOperation(cm.fuop)  
	c:RegisterEffect(e2)  
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_ZOMBIE) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end  
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end  
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateActivation(ev) 
end  
function cm.filter0(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) 
end  
function cm.filter1(c,e)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e) and (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end  
function cm.filter2(c,e,tp,m,f,gc,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)  
end  
function cm.futg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)  
		local res=Duel.GetLocationCountFromEx(tp)>0  
			and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.fuop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local chkf=tp  
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end  
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e)  
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)  
	end  
	if (Duel.GetLocationCountFromEx(tp)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)  
			tc:SetMaterial(mat1)  
			Duel.SendtoDeck(mat1,nil,2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  