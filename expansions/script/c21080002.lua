--圣海德威的开辟
local m=21080002
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,15005130)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_HAND)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(cm.matval1)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(3,m)
	e1:SetCost(cm.spcost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.matval(e,c)
	return (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK)) and aux.IsCodeListed(c,15005130)
end
function cm.mfilter(c)
	return true
end
function cm.matval1(e,c,mg,lc)
	if not aux.IsCodeListed(c,15005130) then return false,nil end
	return true,not mg or mg:IsExists(cm.mfilter,0,nil) and aux.IsCodeListed(c,15005130)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.spfilter(c,e,tp,sc)
	return (aux.IsCodeListed(c,15005130)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,c)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,spcard)
		Duel.ShuffleHand(tp)
	end
end


