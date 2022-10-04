--术结天缘 莉什安蔡莉
function c67200410.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c67200410.spcon)
	e1:SetOperation(c67200410.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)  
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200410,1))
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c67200410.condition)
	e0:SetTarget(c67200410.target)
	e0:SetOperation(c67200410.operation)
	c:RegisterEffect(e0)  
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200410.ctcon)
	--e2:SetTarget(c67200410.cttg)
	e2:SetOperation(c67200410.ctop)
	c:RegisterEffect(e2) 
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200410.scaleup)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)   
end
--
function c67200410.rfilter(c,tp)
	--local tp=c:GetControler()
	return c:IsFaceup() and c:IsSetCard(0x5671) and c:IsAbleToHand() and not c:IsCode(67200410)  and bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end

function c67200410.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end

function c67200410.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c67200410.rfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then 
		return Duel.IsExistingMatchingCard(c67200410.rfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) 
	else
		return rg:GetCount()>1 and rg:IsExists(c67200410.mfilter,1,nil,tp)
	end
end

function c67200410.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c67200410.rfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:FilterSelect(tp,c67200410.mfilter,1,1,nil,tp)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
end
--
function c67200410.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c67200410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x671)
end
function c67200410.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x671,1)
	end
end
--
function c67200410.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200410.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200410.ctfilter,1,nil,tp)
end
function c67200410.actfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHand()
end

function c67200410.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if c:GetCounter(0x671)>5 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200410,2)) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
--
function c67200410.scaleup(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return a
end
--
