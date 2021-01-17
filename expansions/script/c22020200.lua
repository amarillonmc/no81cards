--人理之诗 歌颂的黄金剧场
function c22020200.initial_effect(c)
	aux.AddCodeList(c,22020130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020200+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22020200.target)
	e1:SetOperation(c22020200.activate)
	c:RegisterEffect(e1)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c22020200.con)
	e3:SetValue(c22020200.aclimit)
	c:RegisterEffect(e3)
end
function c22020200.filter(c)
	return c:IsCode(22020130) and c:IsAbleToHand()
end
function c22020200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020200.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020200.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020200.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020200.acfilter(c,code)
	return c:IsFaceup() and c:IsDisabled() and  c:IsCode(code)
end
function c22020200.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c22020200.acfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,re:GetHandler():GetCode())
end
function c22020200.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22020200.con(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c22020200.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end