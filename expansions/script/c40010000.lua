--兽神 烛阴
local m=40010000
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end

function cm.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.shcost)
	e3:SetTarget(cm.shtg)
	e3:SetOperation(cm.shop)
	c:RegisterEffect(e3)
	--Overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CUSTOM+40009964)
	e3:SetCondition(cm.ovlcon)
	e3:SetTarget(cm.ovltg)
	e3:SetOperation(cm.ovlop)
	Duel.RegisterEffect(e3,0)
	local e4=e3:Clone()
	Duel.RegisterEffect(e4,1)
end
function cm.dfilter(c)
	return cm.BeastDeity(c) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function cm.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.shfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and cm.BeastDeity(c)
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetOwner()) and ep==tp
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function cm.ovltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)and Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function cm.ovlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,1,nil)
	if Duel.IsPlayerCanDiscardDeck(tp,1) and tg:GetCount()>0 then
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local gc=g:GetFirst()
		if cm.BeastDeity(gc) and gc:IsRace(RACE_MACHINE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=tg:Select(tp,1,1,nil)
			Duel.HintSelection(tc)
			Duel.DisableShuffleCheck()
			Duel.Overlay(tc:GetFirst(),Group.FromCards(gc))
			Duel.RaiseEvent(gc,EVENT_CUSTOM+40009964,e,REASON_REVEAL,0,tp,0)
		else
			Duel.MoveSequence(gc,1)
		end
	end
end
