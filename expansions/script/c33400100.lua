--刻刻帝-喰时之城
function c33400100.initial_effect(c)
	 c:EnableCounterPermit(0x34f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33400100.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c33400100.counter)
	c:RegisterEffect(e2)
	 --atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c33400100.atkval)
	c:RegisterEffect(e3)
   local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c33400100.atkval(e)
	return Duel.GetMatchingGroupCount(c33400100.PD,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*-100
end
function c33400100.PD(c)
	return c:IsSetCard(0x3340) or c:IsSetCard(0x3341)
end
function c33400100.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c33400100.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x34f,ct,true)
	end
end
function c33400100.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c33400100.filter(c)
	return c:IsCode(33400113) and c:IsAbleToHand()
end
function c33400100.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33400100.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33400100,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
