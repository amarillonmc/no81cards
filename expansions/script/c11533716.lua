--仪水镜的唤魔术 
function c11533716.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE) 
	c:RegisterEffect(e1) 
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11533716,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_HAND) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_SZONE)  
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) and eg:IsExists(function(c) return not c:IsPreviousLocation(LOCATION_DECK) end,1,nil) end) 
	e1:SetCost(c11533716.cost1)
	e1:SetTarget(c11533716.ritg)
	e1:SetOperation(c11533716.riop)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11533716,1)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_DECK) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)  
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) end) 
	e1:SetCost(c11533716.cost1)
	e1:SetTarget(c11533716.ritg)
	e1:SetOperation(c11533716.riop)
	c:RegisterEffect(e1) 
	--draw and to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11533716,2)) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) and eg:IsExists(function(c) return not c:IsPreviousLocation(LOCATION_DECK) end,1,nil) end) 
	e2:SetCost(c11533716.cost2) 
	e2:SetTarget(c11533716.drtdtg)
	e2:SetOperation(c11533716.drtdop)
	c:RegisterEffect(e2)  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11533716,2)) 
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_DECK) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) end) 
	e2:SetCost(c11533716.cost2)
	e2:SetTarget(c11533716.drtdtg)
	e2:SetOperation(c11533716.drtdop)
	c:RegisterEffect(e2) 
	--to deck and sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11533716,3)) 
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_HAND) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) and eg:IsExists(function(c) return not c:IsPreviousLocation(LOCATION_DECK) end,1,nil) end) 
	e3:SetCost(c11533716.cost3) 
	e3:SetTarget(c11533716.tdsptg)
	e3:SetOperation(c11533716.tdspop)
	c:RegisterEffect(e3)  
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11533716,3)) 
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_DECK) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return (re==nil or not re:GetHandler():IsCode(11533716)) end) 
	e3:SetCost(c11533716.cost3)
	e3:SetTarget(c11533716.tdsptg)
	e3:SetOperation(c11533716.tdspop)
	c:RegisterEffect(e3) 
	--rec
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_SUMMON_SUCCESS) 
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c11533716.reccon) 
	e4:SetOperation(c11533716.recop)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5)
end
function c11533716.filter(c,e,tp)
	return c:IsSetCard(0x3a)  
end  
function c11533716.ritg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)  
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c11533716.filter,e,tp,mg,nil,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c11533716.riop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c11533716.filter,e,tp,mg,nil,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11533716.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11533716)==0 end 
	Duel.RegisterFlagEffect(tp,11533716,RESET_CHAIN,0,1)
end 
function c11533716.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c11533716.cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,21533716)==0 end 
	Duel.RegisterFlagEffect(tp,21533716,RESET_PHASE+PHASE_END,0,1)
	c11533716.cost(e,tp,eg,ep,ev,re,r,rp,1)
end 
function c11533716.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c11533716.cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,31533716)==0 end 
	Duel.RegisterFlagEffect(tp,31533716,RESET_PHASE+PHASE_END,0,1)
	c11533716.cost(e,tp,eg,ep,ev,re,r,rp,1)
end 
function c11533716.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c11533716.cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,41533716)==0 end 
	Duel.RegisterFlagEffect(tp,41533716,RESET_PHASE+PHASE_END,0,1)
	c11533716.cost(e,tp,eg,ep,ev,re,r,rp,1)
end 
function c11533716.tdgck(g) 
	return g:IsExists(Card.IsSetCard,1,nil,0x18e,0x3a) 
end 
function c11533716.scfilter(c)
	return c:IsSetCard(0x3a) and c:IsAbleToHand()
end
function c11533716.drtdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11533716.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11533716.drtdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11533716.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
			if dg:CheckSubGroup(c11533716.tdgck,5,5) and Duel.SelectYesNo(tp,aux.Stringid(11533716,0)) then
				local sg=g:SelectSubGroup(tp,c11533716.tdgck,false,5,5) 
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
			end
	end
end 
function c11533716.tdfil(c) 
	if not (c:IsType(TYPE_RITUAL) and c:IsAbleToDeck()) then return false end 
	if c:IsType(TYPE_MONSTER) then 
	return c:IsAttribute(ATTRIBUTE_WATER) 
	elseif c:IsType(TYPE_SPELL) then 
	return true  
	else return false end 
end 
function c11533716.srfil(c,e,tp)
	if not (c:IsSetCard(0x3a) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11533716.tdsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533716.srfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
end 
function c11533716.tdspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.IsExistingMatchingCard(c11533716.srfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then 
		local tc=Duel.SelectMatchingCard(tp,c11533716.srfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
		end
	end  
end
function c11533716.rckfil(c,e,tp) 
	return c:IsSetCard(0x3a) and c:IsSummonPlayer(tp) and c:IsLevelAbove(1) 
end 
function c11533716.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c11533716.rckfil,nil,e,tp):GetCount()>0   
end 
function c11533716.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,11533716)
	local ag=eg:Filter(c11533716.rckfil,nil,e,tp) 
	local lv=ag:GetSum(Card.GetLevel) 
	Duel.Recover(tp,lv*100,REASON_EFFECT) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) end,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lv*100/2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext()  
		end 
	end 
end 





