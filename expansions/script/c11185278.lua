--鳞病的显现
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--effect in grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.effcost)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 and  not Duel.IsExistingMatchingCard(cm.thcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xa450)
end
function cm.fit1(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)and c:IsSetCard(0xa450)
end
function cm.fit2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa450)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.fit1,tp,LOCATION_DECK+LOCATION_EXTRA,0,5,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.fit1,tp,LOCATION_DECK+LOCATION_EXTRA,0,5,5,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fit2,tp,LOCATION_DECK,0,1,nil)
		end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_DECK,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
end
function cm.fit3(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xa450)
end
function cm.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.fit3,tp,LOCATION_GRAVE,0,1,e:GetHandler(),0xa450) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.fit3,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),0xa450)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			local tc=g:GetFirst()
			tc:CreateEffectRelation(e)
			local te=tc.discard_effect
			local tg=te:GetTarget()
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1)
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
					Duel.BreakEffect()
			end
			if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
				Duel.SendtoGrave(sg,REASON_RETURN)
			end
		end
	end

end
function cm.tgfilter(c)
	return c:IsSetCard(0xa450) and c:IsAbleToRemove()
end
function cm.rmfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xa450) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()) and c:IsCode(m) then return false end
	local te=c.discard_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
