--妖精骑士兰斯洛特
function c11513048.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c11513048.lcheck)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11513048) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c11513048.sttg) 
	e1:SetOperation(c11513048.stop) 
	c:RegisterEffect(e1) 
	--rl and sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21513048) 
	e2:SetTarget(c11513048.rsptg) 
	e2:SetOperation(c11513048.rspop) 
	c:RegisterEffect(e2) 
	--to deck 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_TOGRAVE) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,31513048) 
	e3:SetCondition(aux.exccon)  
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c11513048.tdtg) 
	e3:SetOperation(c11513048.tdop) 
	c:RegisterEffect(e3)
end
function c11513048.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end 
function c11513048.xtdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_RITUAL)  
end 
function c11513048.xthfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)   
end 
function c11513048.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513048.xtdfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c11513048.xthfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11513048.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c11513048.xtdfil,tp,LOCATION_HAND,0,nil) 
	local g2=Duel.GetMatchingGroup(c11513048.xthfil,tp,LOCATION_DECK,0,nil) 
	if g1:GetCount()>0 then 
		local rg=g1:Select(tp,1,1,nil)
		if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 and g2:GetCount()>0 then 
			Duel.BreakEffect() 
			local sg=g2:Select(tp,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 
function c11513048.rspfil(c,e,tp)  
	local atk=e:GetHandler():GetMaterial():GetSum(Card.GetBaseAttack)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:GetAttack()<atk and Duel.GetMZoneCount(tp,e:GetHandler())>0  
end  
function c11513048.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c11513048.rspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c11513048.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513048.rspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)~=0 and g:GetCount()>0 then  
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		sc:SetMaterial(Group.FromCards(c)) 
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		if sc:IsCode(11513043) then 
		local atk=e:GetHandler():GetMaterial():GetSum(Card.GetBaseAttack) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1)   
		end   
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_DECKSHF)
		sc:RegisterEffect(e3)
		sc:CompleteProcedure()
	end 
end 
function c11513048.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)	
end 
function c11513048.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513048.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c11513048.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513048.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil)  
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513048,1)) then 
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT) 
		end 
	end 
end   




