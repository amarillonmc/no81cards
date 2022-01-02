--元始飞球秘术·崩炎
local m=13254042
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--[[
	--flame
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--goddamn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--magma
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(cm.cost2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
	]]
	elements={{"tama_elements",{{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_MANA,1}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,g:GetCount(),nil)
	Duel.SendtoDeck(sg,tp,2,REASON_COST)
	local index=tama.save(tama.tamas_sumElements(sg))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	e1:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
			return tama.removeObj(index)
	end)
	Duel.RegisterEffect(e1,tp)
	e:SetLabel(index)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local index=e:GetLabel()
	local obj={}
	if index then obj=tama.get(index) end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,2},{TAMA_ELEMENT_WIND,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,1))
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DESTROY))
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,5},{TAMA_ELEMENT_WATER,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,2))
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_REMOVE))
		local sg=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,3},{TAMA_ELEMENT_EARTH,2}},obj) then
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_ATKCHANGE))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,3))
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,4))
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,5))
		Duel.SetChainLimit(cm.chainlm)
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DAMAGE))
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local index=e:GetLabel()
	local obj={}
	local broken=false
	if index then obj=tama.get(index) end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,2},{TAMA_ELEMENT_WIND,2}},obj) then
		if broken then Duel.BreakEffect() end
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		if ct>0 and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		end
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,3},{TAMA_ELEMENT_WATER,2}},obj) then
		if broken then Duel.BreakEffect() end
		local sg=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
		local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		if ct>0 and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		end
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_FIRE,3},{TAMA_ELEMENT_EARTH,2}},obj) then
		if broken then Duel.BreakEffect() end
		local ct=2000
		if tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then ct=3000 end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ct)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
		broken=true
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.filter1(c)
	return c:IsAbleToDeck() and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
--[[
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_FIRE,2},{TAMA_ELEMENT_WIND,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_FIRE,5},{TAMA_ELEMENT_WATER,5}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function cm.filter1(c)
	return c:IsAbleToDeck() and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,1,nil) end
	local sg=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_FIRE,3},{TAMA_ELEMENT_EARTH,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	--attack up
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(2000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
]]
