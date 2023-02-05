--自奏圣乐的残音
function c79029527.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,79029527+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c79029527.accost) 
	e1:SetTarget(c79029527.actg) 
	e1:SetOperation(c79029527.acop) 
	c:RegisterEffect(e1) 
end 
function c79029527.accost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,3000) end 
	Duel.PayLPCost(tp,3000) 
end 
function c79029527.spfil(c,e,tp,rg) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x11b) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetLevel()==rg:GetCount() 
end 
function c79029527.tdfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  
end 
function c79029527.tdgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c79029527.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,g) 
end 
function c79029527.actg(e,tp,eg,ep,ev,re,r,rp,chk)   
	local g=Duel.GetMatchingGroup(c79029527.tdfil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c79029527.tdgck,1,99,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c79029527.acop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029527.tdfil,tp,LOCATION_REMOVED,0,nil) 
	if g:CheckSubGroup(c79029527.tdgck,1,99,e,tp) then 
		local rg=g:SelectSubGroup(tp,c79029527.tdgck,false,1,99,e,tp) 
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(c79029527.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,rg) then 
		local sg=Duel.SelectMatchingCard(tp,c79029527.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,rg) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(90351981) 
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp) 
end 


