--NGNL 机凯种 距离同步完成剩余251秒
if not pcall(function() require("expansions/script/c60000101") end) then require("script/c60000101") end
local m=60000117
local cm=_G["c"..m]
cm.name="NGNL 机凯种 距离同步完成剩余251秒"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(jkz.acon)
	e3:SetTarget(cm.xxtg)
	e3:SetOperation(cm.xxop)
	c:RegisterEffect(e3)
	local ge1 = jkz.GetCountEffect(c)
end
cm.named_with_ExMachina=true 
function cm.filter(c)
	return c.named_with_ExMachina and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.xxfilter(c)
	return c:IsSetCard(0x6a0)
end
function cm.mkfilter(c)
	return c.named_with_ExMachina and c:IsType(TYPE_LINK) and c:IsAttackAbove(2500)
end
function cm.ttkfilter(c)
	return c:IsCode(60000112)
end
function cm.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	if (not Duel.IsExistingMatchingCard(cm.xxfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(cm.mkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ttkfilter,tp,LOCATION_SZONE,0,1,nil)) then 
	e:SetLabel(1)
	end
end
function cm.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0x6a0) and not c:IsImmuneToEffect(e)
end
function cm.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then 
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil,e)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	end
end











