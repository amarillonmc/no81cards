local m=82209046
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_PZONE,0)  
	e2:SetTarget(cm.tgtg)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)  
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_QUICK_O)   
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)  
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3) 
end
cm.SetCard_01_Kieju=true
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.tgtg(e,c)  
	return cm.isKieju(c:GetCode())
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)  
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)  
	if not tc1 or not tc2 then return false end  
	local scl1=tc1:GetLeftScale()  
	local scl2=tc2:GetRightScale()  
	if scl1>scl2 then scl1,scl2=scl2,scl1 end  
	return scl1==6 and scl2==9 and Duel.GetTurnPlayer()==1-tp and
 (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end  
function cm.spfilter(c,e,tp)  
	return cm.isKieju(c:GetCode()) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsLevelAbove(7) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	local ct2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ct=Duel.GetUsableMZoneCount(tp)
	local loc=0
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then  
		if ct1>0 then ct1=1 end  
		if ct2>0 then ct2=1 end   
		ct=1
	end  
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ct  
	if ct1>0 then loc=loc+LOCATION_HAND end
	if ect>0 and ct2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)  
	if g:GetCount()>0 then
		local sg=g:SelectSubGroup(tp,cm.gcheck,false,1,99,ct1,ct2,ect,ct)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)  
		end
	end  
end  
function cm.exfilter(c)  
	return c:IsLocation(LOCATION_EXTRA) and (c:IsFaceup() and c:IsType(TYPE_PENDULUM))  
end  
function cm.gcheck(g,ct1,ct2,ect,ct)  
	return #g<=ct  
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=ct1  
		and g:FilterCount(cm.exfilter,nil)<=ct2 
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect  
end  