--机关傀儡-原型人偶
local m=82209120
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(m,1)) 
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)  
	e2:SetCountLimit(1)   
	e2:SetCost(cm.sumcost)  
	e2:SetTarget(cm.sumtg)  
	e2:SetOperation(cm.sumop)  
	c:RegisterEffect(e2)  
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,c,tp)
	local mg=Group.Clone(g)
	mg:AddCard(c)
	return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function cm.xyzfilter(c,g)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function cm.chkfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not cm.spfilter(c,e,tp) then return false end
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=1 then return false end
		local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if cg:GetCount()==0 then return false end
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
		if g:GetCount()==0 then return false end
		return g:CheckSubGroup(cm.fselect,1,ft-1,c,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not cm.spfilter(c,e,tp) then return false end
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)

	if ft>0 and g:GetCount()>0 and cg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,ft-1,c,tp)
		if not sg then return end
		sg:AddCard(c)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD) 
			tc:RegisterEffect(e1)   
			tc:RegisterEffect(e2)  
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)~=sg:GetCount() then return end
		local tg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			if rg:GetCount()>0 then
				Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
			end
		end
	end
end

function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.sumfilter(c,e)  
	return c:IsSetCard(0x1083) and c:IsSummonable(true,nil,e)  
end  
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end  
end