--AK-Persona双影夜魔
function c82568092.initial_effect(c)
	aux.EnableDualAttribute(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82568092),LOCATION_MZONE)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568092,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c82568092.rccon)
	e1:SetTarget(c82568092.rctg)
	e1:SetOperation(c82568092.rcop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568092,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c82568092.descon)
	e2:SetTarget(c82568092.destg)
	e2:SetOperation(c82568092.desop)
	c:RegisterEffect(e2)
	--pendulum set
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(82568092,0))
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1,82568192)
	e12:SetRange(LOCATION_PZONE)
	e12:SetTarget(c82568092.pctg)
	e12:SetOperation(c82568092.pcop)
	c:RegisterEffect(e12)
	--spsummon proc
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetCountLimit(1,82568092+EFFECT_COUNT_CODE_OATH)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c82568092.spcon)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568092,3))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c82568092.descost)
	e4:SetCondition(c82568092.descon2)
	e4:SetTarget(c82568092.destg2)
	e4:SetOperation(c82568092.desop2)
	c:RegisterEffect(e4)
end
function c82568092.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() 
end
function c82568092.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568092.desfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(0)
end
function c82568092.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568092.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82568092.desfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	local dam=tg:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c82568092.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82568092.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
		tc=Duel.GetOperatedGroup():GetFirst()
		local dam=tc:GetAttack()
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end

function c82568092.bwfilter(c,e,tp)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsSetCard(0x825) and c:IsFaceup()
end
function c82568092.spcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c82568092.bwfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c82568092.tkfilter(c)
	return c:GetDefense()>0 and c:IsFaceup()
end
function c82568092.rccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLeftScale()==1
end
function c82568092.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:GetDefense()>0 and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568092.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568092.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst():GetDefense()/2
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,tc)
end
function c82568092.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local value=tc:GetDefense()/2
	Duel.Recover(tp,value,REASON_EFFECT)
end
function c82568092.pcfilter(c,code)
	return c:IsCode(code)
end
function c82568092.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c82568092.pcfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetHandler():GetCode())
		 and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)>0 end
end
function c82568092.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82568092.pcfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e:GetHandler():GetCode())
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and Duel.SelectYesNo(tp,aux.Stringid(82568092,3)) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(9)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	tc:RegisterEffect(e2)
	end
	end
end
function c82568092.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLeftScale()==9 and Duel.GetCounter(e:GetHandler():GetControler(),LOCATION_ONFIELD,0,0x5825)>0
end
function c82568092.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	local apn=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	g:Merge(apn)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c82568092.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local apn=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	apn:AddCard(tc)
	if tc:IsRelateToEffect(e) and Duel.GetCounter(e:GetHandler():GetControler(),LOCATION_ONFIELD,0,0x5825)>0 
	   and apn:GetCount()>0 then
		 Duel.Destroy(apn,REASON_EFFECT)
	end
end