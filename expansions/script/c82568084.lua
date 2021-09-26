--AK-薰衣的调香师
function c82568084.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568084.pcon)
	e2:SetTarget(c82568084.splimit)
	c:RegisterEffect(e2)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,82568084+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c82568084.spcon)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568084,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82568084.adcost)
	e3:SetCountLimit(1,82568184)
	e3:SetTarget(c82568084.target)
	e3:SetOperation(c82568084.activate)
	e3:SetValue(c82568084.rdval)
	c:RegisterEffect(e3)
	
end
function c82568084.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82568084.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82568084.bwfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x825) and c:IsFaceup()
end
function c82568084.spcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c82568084.bwfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c82568084.filter(c)
	return c:IsFaceup() and not c:IsCode(82568084) 
end
function c82568084.rdval(e)
	return e:GetHandler():GetAttack()
end
function c82568084.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82568084.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568084.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetAttack())
end
function c82568084.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82568084.filter,tp,LOCATION_MZONE,0,nil)
	local atk=c82568084.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	Duel.Recover(tp,atk,REASON_EFFECT)
end