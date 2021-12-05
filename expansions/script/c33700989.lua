--城市之天台 ～感悟他人的人生～
local m=33700989
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.cfilter(c)
	return not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,ec:GetCode())
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local dcount=dg:GetCount()
	local seq=-1
	local tc=g:GetFirst()
	local rmcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			rmcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		if dg:GetClassCount(Card.GetCode)==dcount then
			Duel.Draw(tp,1,REASON_EFFECT)
		else
			Duel.Recover(tp,dcount*50)
		end
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if rmcard:IsAbleToRemove() then
		Duel.Remove(rmcard)
		if dg:GetClassCount(Card.GetCode)==dcount then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=dg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		else
			Duel.Recover(tp,dcount*100)
		end
	end
end

