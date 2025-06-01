--永夜抄 月见草
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x3620) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		--Debug.Message("1")
		if e:GetLabel()==2 then
			--Debug.Message("2")
			local cg=e:GetLabelObject()
			if cg then Duel.Destroy(cg,REASON_EFFECT) end
			
			--Duel.ConfirmCards(tp,cg)
		end
	end
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hcfil,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(cm.hcfil,tp,LOCATION_HAND,0,1,nil) end
	e:SetLabel(1)
	if Duel.GetTurnPlayer()~=tp then
		--e:SetLabel(1)
	--else
		e:SetLabel(2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.GetMatchingGroup(cm.hcfil,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
		if g then 
			e:SetLabelObject(g)
			g:KeepAlive()
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.hcfil(c)
	return c:IsSetCard(0x3620) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end