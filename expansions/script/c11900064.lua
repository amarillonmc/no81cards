--死灵守护者－阿努比斯
function c11900064.initial_effect(c) 
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(function(e) 
	return not e:GetHandler():IsLocation(LOCATION_GRAVE) end)
	c:RegisterEffect(e1)  
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,11900064)
	e2:SetTarget(c11900064.thtg) 
	e2:SetOperation(c11900064.thop) 
	c:RegisterEffect(e2) 
	--atk 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return (Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)*200)-(Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)*200) end)  
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c11900064.actarget)
	e5:SetCost(c11900064.costchk)
	e5:SetOperation(c11900064.costop) 
	e5:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	c:RegisterEffect(e5)
	--accumulate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_FLAG_EFFECT+11900064)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	c:RegisterEffect(e6)
end 
function c11900064.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsLevel(8) and aux.IsCodeListed(c,11900061)  
end  
function c11900064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c11900064.thfil,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11900064.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end 
function c11900064.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)  
	end 
end 
function c11900064.actarget(e,te,tp) 
	local atk=e:GetHandler():GetAttack()   
	if not te:GetHandler():IsType(TYPE_MONSTER) then return false end 
	return te:GetHandler():GetAttack()<atk and te:GetHandler():IsLocation(LOCATION_MZONE) 
end
function c11900064.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,11900064)
	return Duel.CheckLPCost(tp,ct*800)
end
function c11900064.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end