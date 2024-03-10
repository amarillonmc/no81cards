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
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end
function cm.cfilter2(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end
function cm.cfilterz(c)
	return c:IsFaceup() and cm.Spiritualist(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,40011471) then
		g1:Merge(g2)
	end
	if g1:GetCount()>0 and Duel.IsExistingMatchingCard(cm.cfilterz,tp,LOCATION_MZONE,0,1,nil) then 
		if Duel.IsPlayerAffectedByEffect(tp,40011471) then 
			Duel.SelectYesNo(tp,aux.Stringid(m,2)) 
		else 
			Duel.SelectYesNo(tp,aux.Stringid(m,1))
		end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g1:Select(tp,1,1,nil):GetFirst() 
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		local te,ceg,cep,cev,cre,cr,crp=sg:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())  
		local tg=te:GetTarget()  
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
		te:SetLabelObject(e:GetLabelObject())  
		e:SetLabelObject(te)  
		Duel.ClearOperationInfo(0)  
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.filter(c)
	return cm.MagicCombineMagic(c) and not c:IsCode(m) and c:IsAbleToDeck() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cm.rfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
			Duel.BreakEffect()
			if e:GetLabel()==1 then
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

