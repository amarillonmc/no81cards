--机天使智能化
function c18155051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18155051)
	e1:SetCost(c18155051.cost)
	e1:SetTarget(c18155051.target)
	e1:SetOperation(c18155051.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,18155052)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c18155051.target2)
	e2:SetOperation(c18155051.activate2)
	c:RegisterEffect(e2)
end
function c18155051.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c18155051.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c18155051.spfil(c,e,tp,sc) 
	local lv=sc:GetLevel()
	return c:IsLevelBelow(lv) and c:IsSetCard(0x7bc2) and c:IsAbleToHand()
end
function c18155051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18155051.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c18155051.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc) 
	Duel.ShuffleHand(tp)
	e:SetLabelObject(sc)
end
function c18155051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18155051.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c18155051.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,sc)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c18155051.spfil2(c,e,tp) 
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end 
function c18155051.rmfil2(c) 
	return c:IsSetCard(0x7bc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()  
end 
function c18155051.rgck2(g,e,tp) 
	local sg=Duel.GetMatchingGroup(c18155051.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	return sg:CheckSubGroup(c18155051.spgck2,1,1,e,tp,g)  
end 
function c18155051.spgck2(g,e,tp,rg) 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and rg:CheckWithSumGreater(Card.GetDefense,g:GetSum(Card.GetDefense)) 
end 
function c18155051.target2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c18155051.rmfil2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(c18155051.rgck2,1,3,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end 
function c18155051.activate2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c18155051.rmfil2,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local xg=Duel.GetMatchingGroup(c18155051.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	if g:CheckSubGroup(c18155051.rgck2,1,3,e,tp) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:SelectSubGroup(tp,c18155051.rgck2,false,1,3,e,tp) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		xg:Sub(rg)
		local sc=xg:SelectSubGroup(tp,c18155051.spgck2,0,1,1,e,tp,rg) 
		if not sc then return end
		local zc=sc:GetFirst()
		zc:SetMaterial(rg)
		Duel.SpecialSummon(zc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		zc:CompleteProcedure()   
	end 
end