--魔合成-逆流之冥府
local m=40009679
local cm=_G["c"..m]
cm.named_with_MagicCombineMagic=1
function cm.Spiritualist(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Spiritualist
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.recon1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)   
end
function cm.MagicCombineMagic(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagicCombineMagic
end
function cm.MagicCombineDemon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagicCombineDemon
end
function cm.cfilter6(c)
	return c:IsFaceup() and (cm.MagicCombineDemon(c) or cm.Spiritualist(c))
end
function cm.recon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter6,tp,LOCATION_MZONE,0,1,nil)
end 
function cm.cfilter1(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil  
end
function cm.cfilter2(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY))
	and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil  
end
function cm.cfilterz(c)
	return c:IsFaceup() and cm.Spiritualist(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.IsExistingMatchingCard(cm.cfilterz,tp,4,0,1,nil) then return end
	cm_copy = false
	local g = {}
	if Duel.IsPlayerAffectedByEffect(tp,40011471) then
		g=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE,0,nil)
	else
		g=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_GRAVE,0,nil)
	end
	if #g<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		Duel.Hint(3,tp,HINTMSG_REMOVE)	
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		cm_copy = true
		local te,ceg,cep,cev,cre,cr,crp=sg:GetFirst():CheckActivateEffect(true,true,true)
		e:SetProperty(te:GetProperty())  
		local tg=te:GetTarget()  
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
		te:SetLabelObject(e:GetLabelObject())  
		e:SetLabelObject(te)  
		Duel.ClearOperationInfo(0)  
	end
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c)
	return cm.MagicCombineMagic(c) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if cm_copy then
		cm_copy = false
		local te=e:GetLabelObject()
			if te then  
			e:SetLabelObject(te:GetLabelObject())  
			local op=te:GetOperation()  
				if op then op(e,tp,eg,ep,ev,re,r,rp) end  
			end
		 end  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g2>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end