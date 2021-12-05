local m=53799135
local cm=_G["c"..m]
cm.name="名场景再现"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,2,re:GetHandler():GetCode())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.thoperation)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.thoperation(e,tp,eg,ep,ev,re,r,rp)
	local ac={Duel.GetFlagEffectLabel(1-tp,m)}
	if ac==nil then return end
	Duel.Hint(HINT_CARD,0,m)
	local g=Group.CreateGroup()
	for i=1,#ac do
		local sg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,ac[i])
		for tc in aux.Next(sg) do
			if not g:IsContains(tc) then
				g:AddCard(tc)
				break
			end
		end
	end
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
