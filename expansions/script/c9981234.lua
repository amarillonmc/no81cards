--灭亡迅雷.net
function c9981234.initial_effect(c)
	 --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9981234.handcon)
	c:RegisterEffect(e2)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981234+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981234.cost)
	e1:SetTarget(c9981234.target)
	e1:SetOperation(c9981234.activate)
	c:RegisterEffect(e1)
end
function c9981234.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc9) and c:IsType(TYPE_XYZ)
end
function c9981234.handcon(e)
	return Duel.IsExistingMatchingCard(c9981234.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9981234.costfilter(c,tp)
	return c:IsSetCard(0xbc9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c9981234.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981234.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9981234.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9981234.filter(c,check)
	return c:IsControlerCanBeChanged(check) and c:IsFaceup()
end
function c9981234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=e:GetLabel()==100
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9981234.filter,tp,0,LOCATION_MZONE,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c9981234.filter2(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c9981234.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c9981234.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetValue(9981234)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e5)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981234,0))
end