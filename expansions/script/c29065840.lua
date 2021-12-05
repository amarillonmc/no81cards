--机影的云图
local m=29065840
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Summon/SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87ab))
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition1)
	e3:SetTarget(cm.target1)
	e3:SetOperation(cm.operation1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ALSO_BATTLE_DAMAGE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.condition2)
	e4:SetTarget(cm.target)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(cm.negcon)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
end
function cm.filter1(c)
	local tpe=c:GetOriginalType()&0x7
	return c:IsFaceup() and c:IsSetCard(0x87ab) and tpe&TYPE_MONSTER~=0
end
function cm.addcheck(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x87ab) and not Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c)
end
function cm.check2(c,mc)
	return c:IsCode(mc:GetCode()) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.condition1(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_SZONE,0,1,nil) 
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.addcheck,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function cm.operation1(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,cm.addcheck,tp,LOCATION_DECK,0,1,1,nil,tp)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.condition2(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_SZONE,0,3,nil)
end
function cm.target(e,c)
	return c:IsFaceup() and c:IsSetCard(0x87ab)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_SZONE,0,5,nil)
end
function cm.check(c)
	local tpe=c:GetOriginalType()&0x7
	return tpe&TYPE_MONSTER~=0 and c:IsAbleToDeck()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) and  Duel.NegateEffect(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
