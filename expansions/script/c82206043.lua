local m=82206043
local cm=_G["c"..m]
cm.name="植占师23-熔岩"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)  
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)  
	--fusion  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCountLimit(1,82216043)  
	e2:SetTarget(cm.pftg)  
	e2:SetOperation(cm.pfop)  
	c:RegisterEffect(e2)
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)
end
 
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end  
function cm.pffilter1(c,e)  
	return not c:IsImmuneToEffect(e)  
end  
function cm.pffilter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PLANT) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function cm.pftg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp)  
		local res=Duel.IsExistingMatchingCard(cm.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(cm.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.pfop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local chkf=tp  
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.pffilter1,nil,e)  
	local sg1=Duel.GetMatchingGroup(cm.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(cm.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)  
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
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  
function cm.desfilter1(c)  
	return c:IsFaceup() and c:IsSetCard(0x29d)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x129d) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc~=c and cm.desfilter1(chkc) end  
	if chk==0 then  
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
		if ft<-1 then return false end  
		local loc=LOCATION_ONFIELD  
		if ft==0 then loc=LOCATION_MZONE end  
		e:SetLabel(loc)  
		return Duel.IsExistingTarget(cm.desfilter1,tp,loc,0,1,c)  
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)  
	end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.desfilter1,tp,e:GetLabel(),0,1,1,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then  
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end  
end  