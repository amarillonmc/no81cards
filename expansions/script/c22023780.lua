--人理彼面 迦摩
function c22023780.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020310,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),1,true,true)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023780,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22023780)
	e1:SetCondition(c22023780.chcon)
	e1:SetTarget(c22023780.chtg)
	e1:SetOperation(c22023780.chop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22023780.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22023780.tgcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--change effect ere
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023780,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22023780)
	e4:SetCondition(c22023780.chcon1)
	e4:SetCost(c22023780.erecost)
	e4:SetTarget(c22023780.chtg)
	e4:SetOperation(c22023780.chop)
	c:RegisterEffect(e4)
end
function c22023780.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c22023780.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,re:GetHandler(),1,0,0)
end
function c22023780.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22023780.repop)
end
function c22023780.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end
function c22023780.sdfilter(c)
	return c:GetOwner()==1-tp
end
function c22023780.tgcon(e)
	return Duel.IsExistingMatchingCard(c22023780.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22023780.chcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023780.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end