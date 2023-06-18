--古战士圣徒
function c91000337.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000337.filter,nil,nil,c91000337.matfilter,true)  
	e1:SetDescription(aux.Stringid(91000337,1))
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,91000337)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	c:RegisterEffect(e1)  
	--ia 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCondition(function(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)  
	e2:SetTarget(c91000337.thtg)
	e2:SetOperation(c91000337.thop) 
	c:RegisterEffect(e2) 
	--place 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(91000337,2))
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e3:SetCountLimit(1,19100337) 
	e3:SetCondition(function(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	e3:SetCost(c91000337.plcost)
	e3:SetTarget(c91000337.pltg) 
	e3:SetOperation(c91000337.plop) 
	c:RegisterEffect(e3)
	--ri 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e4:SetCountLimit(1,29100337) 
	e4:SetCondition(function(e) 
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end)
	e4:SetOperation(c91000337.iaop) 
	c:RegisterEffect(e4)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000337.spccost)
	e0:SetOperation(c91000337.spcop)
	c:RegisterEffect(e0)   
	if not c91000337.global_check then
		c91000337.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000337.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
c91000337.SetCard_Dr_AcWarrior=true 
function c91000337.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,91000337,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000337.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000337)==0 
end
function c91000337.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)  
	e2:SetValue(c91000337.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000337.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000337.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL)  
end
function c91000337.matfilter(c,e,tp,chk)
	return not chk or true 
end  
function c91000337.smfil(c) 
	return c:IsSummonable(true,nil) and c:IsLevel(10)   
end 
function c91000337.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000337.smfil,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND) 
end 
function c91000337.smop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c91000337.smfil,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Summon(tp,tc,true,nil) 
	end 
end 
function c91000337.iaop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE) 
	e2:SetValue(c91000337.efilter)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)  
	e2:SetValue(c91000337.efilter)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp) 
end 
function c91000337.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetHandler():IsLevel(10) and te:IsActiveType(TYPE_MONSTER) and tp==p
end
function c91000337.rlfil(c) 
	return c:IsLevel(10) and c:IsReleasable()  
end 
function c91000337.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c91000337.rlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c91000337.rlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler()) 
	Duel.Release(g,REASON_COST)
end 
function c91000337.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsForbidden() end 
end 
function c91000337.plop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,2)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1) 
		--to deck and draw 
		local e2=Effect.CreateEffect(c) 
		e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
		e2:SetType(EFFECT_TYPE_IGNITION) 
		e2:SetRange(LOCATION_SZONE) 
		e2:SetCountLimit(1)  
		e2:SetTarget(c91000337.tddtg) 
		e2:SetOperation(c91000337.tddop) 
		c:RegisterEffect(e2)
	end
end 
function c91000337.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsLevel(10) end,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return x>0 and Duel.IsExistingMatchingCard(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c91000337.tddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsLevel(10) end,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if x>0 and g:GetCount()>0 then 
		local sg=g:Select(tp,1,x,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
			Duel.BreakEffect() 
			Duel.Draw(tp,1,REASON_EFFECT)  
		end   
	end 
end 
function c91000337.filters(c)
	return c:IsFaceup() and c:IsLevel(10) and c:IsType(TYPE_MONSTER)
end
function c91000337.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c91000337.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c91000337.filter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c91000337.filters,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			end
	local ct=Duel.GetMatchingGroupCount(c91000337.filters,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c91000337.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c91000337.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end


