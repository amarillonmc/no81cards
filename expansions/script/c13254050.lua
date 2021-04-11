--飞球之魔能弹
local m=13254050
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
end
function cm.tdfilter(c)
	return c:IsAbleToDeckAsCost() and tama.tamas_getElementCount(c,TAMA_ELEMENT_MANA)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,60,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabelObject(sg)
	sg:KeepAlive()
end
function cm.rfilter(c)
	return (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()) and c:IsAbleToRemove()
end
function cm.cfilter(c)
	return c:IsCode(13254048) and c:IsFaceup()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then return end
	local t=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local j=tama.tamas_getElementCount(tama.tamas_sumElements(e:GetLabelObject()),TAMA_ELEMENT_MANA)
	local i=0
	while i<j and (i==0 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) do
		Duel.BreakEffect()
		local t1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		local t2=Duel.IsExistingMatchingCard(cm.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil)

		local op=0
		if t then
			t=Duel.SelectYesNo(tp,aux.Stringid(m,0))
		end
		if not t then
			local x={}
			local y={}
			local ct=1
			if t1 then x[ct]=aux.Stringid(m,2) y[ct]=1 ct=ct+1 end
			x[ct]=aux.Stringid(m,3) y[ct]=2 ct=ct+1
			if t2 then x[ct]=aux.Stringid(m,4) y[ct]=3 ct=ct+1 end
			local sp=Duel.SelectOption(tp,table.unpack(x))
			op=y[sp+1]
		end

		if op==1 or t then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if op==2 or t then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
		if op==3 or t then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
		i=i+1
	end
	e:GetLabelObject():DeleteGroup()
end
