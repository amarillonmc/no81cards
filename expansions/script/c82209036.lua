local m=82209036
local cm=_G["c"..m]
--虚幻的谢幕
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--tohand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2) 
	--Activate  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1)) 
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.fuscost)
	e3:SetTarget(cm.fustg)  
	e3:SetOperation(cm.fusop)  
	c:RegisterEffect(e3)   
end
function cm.costfilter(c,tp)  
	local code=c:GetOriginalCodeRule()
	return c:IsType(TYPE_MONSTER) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,code) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,code)  
end  
function cm.thfilter(c,code)  
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetOriginalCodeRule()~=code 
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,cm.costfilter,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
	local g=Duel.SelectReleaseGroupEx(tp,cm.costfilter,1,1,nil,tp) 
	e:SetLabel(g:GetFirst():GetOriginalCodeRule())
	Duel.Release(g,REASON_COST)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,0) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,code) 
	g1:Merge(g2)
	if g1:GetCount()>0 then  
		Duel.SendtoHand(g1,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g1)  
	end  
	--local e1=Effect.CreateEffect(e:GetHandler())  
	--e1:SetType(EFFECT_TYPE_FIELD)  
	--e1:SetCode(EFFECT_CANNOT_TO_HAND)  
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	--e1:SetTargetRange(1,0)  
	--e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK+LOCATION_GRAVE))  
	--e1:SetReset(RESET_PHASE+PHASE_END)  
	--Duel.RegisterEffect(e1,tp)  
end 
function cm.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end  
function cm.filter0(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()  
end  
function cm.filter1(c,e)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)  
end  
function cm.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9b) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function cm.fustg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_GRAVE,0,nil)  
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.fusop(e,tp,eg,ep,ev,re,r,rp)  
	local chkf=tp  
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e)  
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)  
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure() 
	end
	--local e1=Effect.CreateEffect(e:GetHandler())  
	--e1:SetType(EFFECT_TYPE_FIELD)  
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	--e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	--e1:SetTargetRange(1,0)  
	--e1:SetTarget(cm.splimit)  
	--e1:SetReset(RESET_PHASE+PHASE_END)  
	--Duel.RegisterEffect(e1,tp)   
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_EXTRA) 
end  