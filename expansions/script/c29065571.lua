--
function c29065571.initial_effect(c) 
	aux.AddCodeList(c,29065577)
	c:EnableCounterPermit(0x11ae)   
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,29065577,c29065571.fusfilter,1,false,false)
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)	
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87af))
	e1:SetValue(800)
	e1:SetCondition(c29065571.adcon1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)	
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87af))
	e1:SetValue(1600)
	e1:SetCondition(c29065571.adcon2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)   
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e6:SetType(EFFECT_TYPE_QUICK_O)  
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCode(EVENT_CHAINING) 
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetTarget(c29065571.target) 
	e6:SetCondition(c29065571.condition)	
	e6:SetOperation(c29065571.activate) 
	e6:SetCountLimit(1)  
	c:RegisterEffect(e6)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c29065571.lrop)
	c:RegisterEffect(e4)
end
function c29065571.fusfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsRace(RACE_DRAGON)
end
function c29065571.adcon1(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetFlagEffect(29065571)<=0
end
function c29065571.adcon2(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetFlagEffect(29065571)>0
end
function c29065571.ckfil(c)
	return c:IsSetCard(0x87af) and not c:IsCode(29065571)
end
function c29065571.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and rc:GetControler()~=tp and  Duel.IsExistingMatchingCard(c29065571.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c29065571.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	Duel.SetChainLimit(c29065571.chlimit) 
end
end 
function c29065571.chlimit(e,ep,tp) 
	return tp==ep 
end
function c29065571.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	--direct attack  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(29065571,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29065571,0))
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
end
function c29065571.lrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return false end
end