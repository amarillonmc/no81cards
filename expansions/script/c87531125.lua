--死冥的死配 茉莉安
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableExtraDeckSummonCountLimit()
	--送去墓地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.tgcon)
    e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
    --特殊召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=true
    if e:GetHandler():IsLocation(LOCATION_HAND) then tg=Duel.GetTurnPlayer()==tp end
	return tg
end
function s.costfilter(c)
	return c:IsSetCard(0x364b) and not c:IsPublic()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end    
end
function s.cfilter(c)
	return c:IsSetCard(0x364b) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=e:GetLabel()
	if chk==0 then 
    	if e:GetLabel()==100 then
    		return e:GetHandler():IsAbleToGrave()
        else return false end
	end    
    local cost=0
    local con=0
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND,0,e:GetHandler())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
        cost=1        
	end
    if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then con=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
    local ch=Duel.GetCurrentChain()
    local te,tep=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if (con~=0 or cost~=0)and ch>1 and te:IsActiveType(TYPE_MONSTER) then
    	e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)      
    end
    e:SetLabel(cost,con)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local cost,con=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
    	local ch=Duel.GetCurrentChain()    	
    	if (con~=0 or cost~=0) and ch>=2 then
        	local te,tep=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if te:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ch-1) then
        		Duel.BreakEffect()
        		Duel.NegateEffect(ch-1)
			end 
		end               
	end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    if re and re:GetHandler():IsSetCard(0x364b) then
    	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)    	
    end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
    	and re and re:GetHandler():IsSetCard(0x364b) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,nil) 
        and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,1,nil)
    	if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
    end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--额外自肃    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.exsplimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)       
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.excheckop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)       
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(92345028)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x364b) and c:IsRace(RACE_ZOMBIE)
end
function s.exsplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and aux.ExtraDeckSummonCountLimit[sump]<=0
end
function s.excfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.excheckop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.excfilter,1,nil,tp) then
		aux.ExtraDeckSummonCountLimit[tp]=aux.ExtraDeckSummonCountLimit[tp]-1
	end
	if eg:IsExists(s.excfilter,1,nil,1-tp) then
		aux.ExtraDeckSummonCountLimit[1-tp]=aux.ExtraDeckSummonCountLimit[1-tp]-1
	end
end