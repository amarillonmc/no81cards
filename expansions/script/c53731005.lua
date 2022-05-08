local m=53731005
local cm=_G["c"..m]
cm.name="狂喑血法师 塞林"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)end)
	e1:SetOperation(cm.rit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return r&REASON_EFFECT~=0 end)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.rit(e,tp,eg,ep,ev,re,r,rp)
	local op,ct=0,0
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) else op=Duel.SelectOption(tp,aux.Stringid(m,1)) end
	if op==0 then ct=3 else ct=-3 end
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,tp,LOCATION_HAND,0,nil)
	cm.lvop(hg,c,ct)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) cm.lvop(eg:Filter(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,nil),c,ct) end)
	Duel.RegisterEffect(e2,tp)
	if op==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.lvop(g,c,ct)
	for lvc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0xfe0000)
		lvc:RegisterEffect(e1)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
