--翼冠法·血誓
function c11570016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11570016.target)
	e1:SetOperation(c11570016.activate)
	c:RegisterEffect(e1)
	--sp 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c11570016.sptg)
	e1:SetOperation(c11570016.spop)
	c:RegisterEffect(e1)
end 
function c11570016.xxfil(c,e,tp)  
	if not ((c:IsLocation(LOCATION_DECK+LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x810) and c:IsType(TYPE_MONSTER)) then return false end 
	return (c:IsLocation(LOCATION_HAND) or c:IsAbleToHand()) and (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeckAsCost()) and (c:IsLocation(LOCATION_REMOVED) or c:IsAbleToRemove()) and (c:IsLocation(LOCATION_GRAVE) or c:IsAbleToGrave()) and (c:IsLocation(LOCATION_MZONE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end 
function c11570016.xxgck(g) 
	return g:GetClassCount(Card.GetLocation)==g:GetCount()  
end 
function c11570016.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11570016.xxfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c11570016.xxgck,3,3) end  
end
function c11570016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11570016.xxfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp) 
	if g:CheckSubGroup(c11570016.xxgck,3,3) then 
		local sg=g:SelectSubGroup(tp,c11570016.xxgck,false,3,3) 
		local sc1=sg:Select(tp,1,1,nil):GetFirst()
		local sc2=sg:Filter(aux.TRUE,sc1):Select(tp,1,1,nil):GetFirst() 
		local xsg=Group.FromCards(sc1,sc2) 
		local sc3=sg:Filter(aux.TRUE,xsg):GetFirst() 
		local loc1=sc1:GetLocation() 
		local loc2=sc2:GetLocation()
		local loc3=sc3:GetLocation() 
		for i=1,3 do 
			if i==1 then sc,loc=sc1,loc2 end 
			if i==2 then sc,loc=sc2,loc3 end 
			if i==3 then sc,loc=sc3,loc1 end 
			if loc==LOCATION_MZONE then 
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			elseif loc==LOCATION_GRAVE then 
				Duel.SendtoGrave(sc,REASON_EFFECT)
			elseif loc==LOCATION_HAND then 
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
			elseif loc==LOCATION_DECK then 
				Duel.SendtoDeck(sc,nil,2,REASON_EFFECT)
			elseif loc==LOCATION_REMOVED then  
				Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			end 
		end 
	end 
end 
function c11570016.spfil(c) 
	return c:IsSpecialSummonable() and c:IsSetCard(0x810)
end 
function c11570016.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11570016.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function c11570016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11570016.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummonRule(tp,tc) 
	end 
end 
