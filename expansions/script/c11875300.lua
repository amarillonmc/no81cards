--火焰纹章士 马尔斯
function c11875300.initial_effect(c) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	e1:SetValue(function(e,c)
	return c==e:GetHandler() end)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11875300)
	e2:SetTarget(c11875300.thtg)
	e2:SetOperation(c11875300.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--place 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,21875300) 
	e4:SetCondition(c11875300.plcon)
	e4:SetTarget(c11875300.pltg) 
	e4:SetOperation(c11875300.plop) 
	c:RegisterEffect(e4) 
end
c11875300.SetCard_tt_FireEmblem=true  
function c11875300.thfilter(c)
	return c.SetCard_tt_FireEmblem and c:IsType(TYPE_MONSTER) and not c:IsCode(11875300) and c:IsAbleToHand()
end
function c11875300.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11875300.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11875300.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11875300.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11875300.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11875300.splimit(e,c)
	return not c.SetCard_tt_FireEmblem 
end
function c11875300.plcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(11875299) end,tp,LOCATION_MZONE,0,1,nil)   
end 
function c11875300.plfil(c) 
	return c:IsCode(11875306) and not c:IsForbidden()  
end 
function c11875300.pltg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11875300.plfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)==0 end 
end  
function c11875300.plop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11875300.plfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)==0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)	 
	end 
end 



