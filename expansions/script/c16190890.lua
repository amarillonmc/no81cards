--超跃星★永不黯淡的色彩
local s,id,o=GetID()
function s.initial_effect(c)
	--适用效果
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0xca0) and c:IsAbleToRemoveAsCost() and c:GetLink()>0
end
function s.lkfilter(c,e,tp,mg)
	return c:IsSetCard(0xca0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:GetLink()>0  
    	and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 	
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xca0) and c:IsLevel(4)
    	and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and Duel.GetMZoneCount(tp,mg)>0
end
function s.fselect(g,link)
	return g:GetSum(Card.GetLink)<=link
end
function s.rselect(g,b1,b2)
	return (b1 and Duel.GetLocationCountFromEx(tp,tp,g)>0) or (b2 and Duel.GetMZoneCount(tp,g)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)    
	local b1=sg:CheckSubGroup(s.fselect,1,sg:GetCount(),mg:GetSum(Card.GetLink))
    local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
	if chk==0 then 
    	if e:GetLabel()==100 then
    		return mg:GetCount()>0 and (b1 or b2)
        else return false end
    end       
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=mg:SelectSubGroup(tp,s.rselect,false,1,mg:GetCount(),b1,b2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
    e:SetLabel(rg:GetSum(Card.GetLink))
	e:SetLabelObject(rg)
    rg:KeepAlive()
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spselect(g,link)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and g:GetSum(Card.GetLink)<=link
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local link=e:GetLabel()
    local og=e:GetLabelObject()
    local sg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,e,tp,og)    
	local b1=sg:CheckSubGroup(s.fselect,1,sg:GetCount(),link)
    local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,og)
    local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft1
	local ct1=math.min(ft1,ect)	
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct1=1 end
    local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct2=math.min(ft2,link)	
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct2=1 end
    local s1=b1 and ct1>0
    local s2=b2 and ft2>0
    if  s1 or s2 then
    	local op=aux.SelectFromOptions(tp,
			{s1,aux.Stringid(id,1),1},
			{s1,aux.Stringid(id,2),2})
    	if op==1 then
    		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lg=sg:SelectSubGroup(tp,s.spselect,false,1,ct1,link)
			if lg and Duel.SpecialSummon(lg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
        		for sc in aux.Next(lg) do
            		sc:CompleteProcedure()
            	end
        	end
    	elseif op==2 then
    		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,og)
        	if g:GetCount()>0 then
        		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local pg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct2)
				if pg then
        			Duel.SpecialSummon(pg,0,tp,tp,false,false,POS_FACEUP)
            	end    
        	end
    	end
    end    
    og:DeleteGroup()
end