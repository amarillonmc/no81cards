--测试 
function c13131364.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)  
	--fusion 
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13131364,0)) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c13131364.ctcon)
	e1:SetOperation(c13131364.ctop)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,13131364)  
	e2:SetTarget(c13131364.rmtg) 
	e2:SetOperation(c13131364.rmop) 
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwner():GetCounter(0x1041)>0 end)
	c:RegisterEffect(e3) 
	--p set 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c13131364.pencon)
	e4:SetTarget(c13131364.pentg)
	e4:SetOperation(c13131364.penop)
	c:RegisterEffect(e4)
end
function c13131364.ctfilter(c,tp)
	return c:IsCanAddCounter(0x1041,1)
end
function c13131364.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13131364.ctfilter,1,nil,tp)
end
function c13131364.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13131364.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1041,1)
		tc=g:GetNext()
	end 
end  
function c13131364.rmfil(c) 
	return c:GetCounter(0x1041)>0 and c:IsAbleToRemove()  
end 
function c13131364.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c13131364.rmfil,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE) 
end 
function c13131364.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c13131364.rmfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) 
	end 
end 
function c13131364.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c13131364.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c13131364.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end












