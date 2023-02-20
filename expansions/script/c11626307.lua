--害虫滋生
function c11626307.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11626307,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCost(c11626307.accost)
	e1:SetTarget(c11626307.actg) 
	e1:SetOperation(c11626307.acop) 
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11626307,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_ACTIVATE) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCost(c11626307.accost2)
	e2:SetTarget(c11626307.actg2) 
	e2:SetOperation(c11626307.acop2) 
	c:RegisterEffect(e2) 
	if not c11626307.global_check then
		c11626307.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c11626307.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	Duel.AddCustomActivityCounter(11626307,ACTIVITY_SPSUMMON,c11626307.counterfilter)
end  
function c11626307.counterfilter(c)
	return c.SetCard_YM_Crypticinsect 
end
function c11626307.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	if rc:IsType(TYPE_MONSTER) and not rc.SetCard_YM_Crypticinsect then 
		Duel.RegisterFlagEffect(rp,11626307,RESET_PHASE+PHASE_END,0,1) 
	end
end
function c11626307.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFlagEffect(tp,11626307)==0 and Duel.GetCustomActivityCount(11626307,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c11626307.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)   
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626307.splimit)
	Duel.RegisterEffect(e2,tp) 
end
function c11626307.splimit(e,c)
	return not c.SetCard_YM_Crypticinsect   
end
function c11626307.actlimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and not rc.SetCard_YM_Crypticinsect
end 
function c11626307.dpbfil(c) 
	return c:IsAbleToDeck() and c.SetCard_YM_Crypticinsect and c:IsType(TYPE_MONSTER)
end 
function c11626307.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11626307.dpbfil,tp,LOCATION_DECK,0,2,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11626307.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11626307.dpbfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,2,2,nil)
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ShuffleDeck(tp) 
		Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT) 
		if not tc:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
		local xg=sg:Filter(aux.TRUE,tc) 
		Duel.SendtoHand(xg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,xg) 
	end 
end 
--
function c11626307.costfil(c) 
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_MONSTER)
end 
function c11626307.accost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFlagEffect(tp,11626307)==0 and Duel.GetCustomActivityCount(11626307,tp,ACTIVITY_SPSUMMON)==0 and Duel.CheckReleaseGroup(tp,c11626307.costfil,1,nil,tp) end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(1,0) 
	e1:SetValue(c11626307.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)   
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11626307.splimit)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.SelectReleaseGroup(tp,c11626307.costfil,1,1,nil,tp)
	Duel.Release(g,REASON_COST) 
end
function c11626307.actg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11626307.dpbfil,tp,LOCATION_DECK,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11626307.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11626307.dpbfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,2,2,nil)
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ShuffleDeck(tp) 
		Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT) 
		if not tc:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp)
		tc:ReverseInDeck()
		local xg=sg:Filter(aux.TRUE,tc) 
		Duel.SendtoHand(xg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,xg)
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 







