--魔合成-跨越非业的死亡
local m=40009673
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
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.MagicCombineMagic(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagicCombineMagic
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
	return cm.MagicCombineMagic(c) and not c:IsCode(m) and c:IsAbleToDeck() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.rpfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cm.rfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsFaceup() and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
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
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_REMOVED,0,1,1,nil)
			if #sg>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
end

