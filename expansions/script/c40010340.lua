--龙刻魔道士 利亚法尔
local m=40010340
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.Crimsonmoon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1   
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_LEVEL)
	e11:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--Effect 1
--Effect 2
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
	return c:IsLevel(1) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(cm.thfilter,1,nil)  then
				if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil)
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
					g:Sub(sg)
				end
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				Duel.ShuffleDeck(tp)
			end
		end
	end
end

