--大群之铭 奠基者
function c79078001.initial_effect(c)
	--zone 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,79078001) 
	e1:SetCost(aux.bfgcost) 
	e1:SetTarget(c79078001.zntg) 
	e1:SetOperation(c79078001.znop)
	c:RegisterEffect(e1)
	c79078001.remove_effect=e1
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,79078001+1500)
	e2:SetCondition(c79078001.condition)
	e2:SetTarget(c79078001.target)
	e2:SetOperation(c79078001.operation)
	c:RegisterEffect(e2)
end
c79078001.named_with_Massacre=true
function c79078001.zntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetFlagEffect(tp,79078001)==0 end  
	Duel.RegisterFlagEffect(tp,79078001,RESET_CHAIN,0,1) 
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,nil) 
	e:SetLabel(zone)
end 
function c79078001.znop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local zone=e:GetLabel() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79078001.splimit)
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetCondition(c79078001.sscon) 
	e2:SetOperation(c79078001.ssop) 
	e2:SetLabel(zone) 
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetCondition(c79078001.rmcon) 
	e3:SetOperation(c79078001.rmop) 
	e3:SetLabel(zone) 
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp) 
end 
function c79078001.splimit(e,c)
	return not c:IsRace(RACE_FISH)
end
function c79078001.ckfil1(c,e,tp,zone) 
	return c.named_with_Massacre and c:GetSequence()==math.log(zone,2)
end 
function c79078001.sscon(e,tp,eg,ep,ev,re,r,rp) 
	local zone=e:GetLabel()
	return eg:IsExists(c79078001.ckfil1,1,nil,e,tp,zone) and Duel.IsPlayerCanDiscardDeck(tp,3)
end 
function c79078001.ssop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79078001) 
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end 
function c79078001.ckfil2(c,e,tp,zone) 
	return c.named_with_Massacre and c:GetPreviousSequence()==math.log(zone,2)
end 
function c79078001.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	local zone=e:GetLabel()
	return eg:IsExists(c79078001.ckfil2,1,nil,e,tp,zone)
end  
function c79078001.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79078001) 
	Duel.Recover(tp,700,REASON_EFFECT)
end 
function c79078001.condition(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_FISH>0 
end
function c79078001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,79078001)==0 end  
	Duel.RegisterFlagEffect(tp,79078001,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c79078001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(79078001,1)) then 
	Duel.DiscardDeck(tp,2,REASON_EFFECT) 
	end 
	end
end


