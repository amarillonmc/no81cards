--开天辟地的炼金师 卡莉奥斯特萝
function c11561008.initial_effect(c)
	--cancan 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561008,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_SPSUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) 
	e1:SetCountLimit(1,11561008) 
	e1:SetCost(c11561008.cancost)
	e1:SetTarget(c11561008.cantg) 
	e1:SetOperation(c11561008.canop) 
	c:RegisterEffect(e1) 
	--change
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561008,2))
	e2:SetCategory(CATEGORY_ANNOUNCE) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,21561008) 
	e2:SetTarget(c11561008.cgtg) 
	e2:SetOperation(c11561008.cgop)  
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(11561008,ACTIVITY_SPSUMMON,c11561008.counterfilter)
end
function c11561008.counterfilter(c)
	return not (not c:IsRace(RACE_SPELLCASTER) and not c:IsSummonLocation(LOCATION_EXTRA)) 
end
function c11561008.cancost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11561008,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and not c:IsLocation(LOCATION_EXTRA) end)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11561008.pbfil(c) 
	return c:IsRace(RACE_SPELLCASTER) and not c:IsPublic()   
end 
function c11561008.pbgck(g) 
	return g:GetClassCount(Card.GetLevel)==1 and g:GetClassCount(Card.GetAttribute)==g:GetCount()  
end 
function c11561008.cantg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11561008.pbfil,tp,LOCATION_HAND,0,nil) 
	if chk==0 then return g:CheckSubGroup(c11561008.pbgck,2,7) end 
end 
function c11561008.spfil(c,e,tp,sg) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_SPELLCASTER) and sg:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()) 
end 
function c11561008.thfil(c,e,tp,sg) 
	return c:IsAbleToHand() and c:IsRace(RACE_SPELLCASTER) and sg:IsExists(Card.IsLevel,1,nil,c:GetLevel()) 
end 
function c11561008.canop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11561008.pbfil,tp,LOCATION_HAND,0,nil) 
	local pg=g:SelectSubGroup(tp,c11561008.pbgck,false,2,7) 
	if not g:CheckSubGroup(c11561008.pbgck,2,7) then return end   
	Duel.ConfirmCards(1-tp,pg) 
	Duel.ShuffleHand(tp)   
	local x=pg:GetCount() 
	if pg and x>0 then 
		if x>=2 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)	
		end   
		if x>=3 and Duel.IsExistingMatchingCard(c11561008.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,pg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			local sg=Duel.SelectMatchingCard(tp,c11561008.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,pg) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		end   
		if x>=4 and Duel.IsExistingMatchingCard(c11561008.thfil,tp,LOCATION_DECK,0,1,nil,e,tp,pg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			local sg=Duel.SelectMatchingCard(tp,c11561008.thfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,pg) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)  
		end 
	end 
end 
function c11561008.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.ShuffleHand() 
end 
function c11561008.cgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	e:SetLabel(Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL))
end 
function c11561008.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0) 
	e1:SetTarget(function(e,c)
	return c:IsCode(11561008) end) 
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 







