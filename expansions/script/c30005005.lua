--恶染侵覆
local m=30005005
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hand)
	c:RegisterEffect(e2)
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true  end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,2,nil)  
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local g1=Duel.GetOperatedGroup()
		g1:KeepAlive()
		e:SetLabelObject(g1)		   
	end
end
function cm.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,0xe000e0)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)   
	Duel.Hint(HINT_ZONE,tp,flag)
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	 local seq=e:GetLabel()
	local c=e:GetHandler()
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(seq)
	Duel.RegisterEffect(e2,tp)
  if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then 
  Duel.Draw(tp,1,REASON_EFFECT)
  end
  if e:GetLabelObject() and e:GetLabelObject():GetCount()>1  then 
	local mg=Duel.GetRitualMaterial(tp)  
	if  Duel.IsExistingMatchingCard(aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_REMOVED,0,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater") then 
		local mg=Duel.GetRitualMaterial(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_REMOVED,0,1,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat) 
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	 end
  end
end
function cm.disable(e,c)
	local seq=e:GetLabel()
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return (cseq==seq and  cloc==loc)  and math.abs(cseq-seq)==0 and c:IsFaceup()
end
function cm.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL)
end
