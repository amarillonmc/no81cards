--古战士常青
function c91000334.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000334.filter,nil,nil,c91000334.matfilter,true) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,91000334)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	c:RegisterEffect(e1)   
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e2:SetTarget(c91000334.thtg) 
	e2:SetOperation(c91000334.thop) 
	c:RegisterEffect(e2)  
	--immune
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD) 
	--e3:SetCode(EFFECT_IMMUNE_EFFECT) 
	--e3:SetRange(LOCATION_MZONE) 
	--e3:SetTargetRange(LOCATION_MZONE,0) 
	--e3:SetTarget(function(e,c) 
	--return c:IsLevel(10) end)
	--e3:SetValue(function(e,te)
	--return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsLevelBelow(10) or te:GetHandler():IsRankBelow(10)) end)
	--c:RegisterEffect(e3) 
	--to grave
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1) 
	e3:SetCondition(c91000334.tgcon) 
	e3:SetOperation(c91000334.tgop)
	c:RegisterEffect(e3) 
	--ri 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCountLimit(1,29100334) 
	e4:SetCondition(function(e) 
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e4:SetOperation(c91000334.riop) 
	c:RegisterEffect(e4)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000334.spccost)
	e0:SetOperation(c91000334.spcop)
	c:RegisterEffect(e0)   
	if not c91000334.global_check then
		c91000334.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000334.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
c91000334.SetCard_Dr_AcWarrior=true 
function c91000334.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,91000334,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000334.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000334)==0 
end
function c91000334.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c91000334.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000334.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000334.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL) 
end
function c91000334.matfilter(c,e,tp,chk)
	return not chk or true 
end 
function c91000334.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)  and c:IsLevel(10)   
end 
function c91000334.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000334.thfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end 
function c91000334.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c91000334.thfil,tp,LOCATION_GRAVE,0,nil)   
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end 
function c91000334.tgcon(e,tp,eg,ep,ev,re,r,rp)
   
	return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,POS_FACEUP_DEFENSE)  
end 
function c91000334.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p=Duel.GetTurnPlayer() 
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil,POS_FACEUP_DEFENSE) 
	if g:GetCount()>0 then 
		Duel.Hint(HINT_CARD,0,91000334) 
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)   
	end 
end 
function c91000334.rifil(c,e,tp) 
	return c:IsType(TYPE_RITUAL) and c:IsLevel(10) and c:IsAbleToHand() 
end  
function c91000334.riop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(function(e,c) 
	return c:IsLevel(10) end) 
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsLevelBelow(10) or te:GetHandler():IsRankBelow(10)) end)
	e1:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e1,tp) 
end 



