--甜心机仆 星空的礼物
dofile("expansions/script/c9910550.lua")
function c9910551.initial_effect(c)
	--special summon
	QutryTxjp.AddSpProcedure(c,9910551)
	--flag
	QutryTxjp.AddTgFlag(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c9910551.thcost)
	e2:SetTarget(c9910551.thtg)
	e2:SetOperation(c9910551.thop)
	c:RegisterEffect(e2)
end
function c9910551.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910551.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9910551.thfilter(c)
	return c:IsSetCard(0x3951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910551.rmfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToRemove() and not c:IsCode(9910551)
end
function c9910551.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=5 then return end
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6)
	if g:GetCount()==0 then return end
	Duel.DisableShuffleCheck()
	if g:IsExists(c9910551.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910551,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c9910551.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		g:Sub(sg)
	end
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910551.rmfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910551,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc2=g2:Select(tp,1,1,nil):GetFirst()
		if tc2 and Duel.Remove(tc2,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc2:RegisterFlagEffect(9910551,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc2)
			e1:SetCountLimit(1)
			e1:SetCondition(c9910551.retcon)
			e1:SetOperation(c9910551.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9910551.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(9910551)~=0
end
function c9910551.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
