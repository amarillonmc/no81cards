--UESTC·实验室的实验准备
local m=10400015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10400015,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10400015+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10400015.target)
	e1:SetOperation(c10400015.activate)
	c:RegisterEffect(e1)
end
function c10400015.filter(c)
	return  c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end

function c10400015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10400015.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10400015.activate(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10400015.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	e:SetLabel(g:GetFirst():GetCode())
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCode(EFFECT_CANNOT_ACTIVATE)
	e11:SetTargetRange(1,1)
	e11:SetValue(c10400015.aclimit)
	e11:SetLabel(e:GetLabel())
	e11:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e11,tp)
end
function c10400015.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end