--NGNL 种族之棋 Ex-Machina
local m=60000112
local cm=_G["c"..m]
cm.name="NGNL 种族之棋 Ex-Machina"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetTarget(cm.xxtg)
	e3:SetOperation(cm.xxop)
	c:RegisterEffect(e3) 
end
cm.named_with_ExMachina=true 
cm.named_with_Chess=true 
function cm.thfilter(c)
	return c.named_with_ExMachina and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.atktg(e,c)
	return c.named_with_ExMachina
end
function cm.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x6a0) then 
	e:SetLabel(1)
	end
end
function cm.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then 
	Duel.SendtoHand(c,tp,REASON_EFFECT)
	end
end 