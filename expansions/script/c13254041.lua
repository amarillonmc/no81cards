--元始飞球秘术·飓风
local m=13254041
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
	--hurricane
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--steam
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--sandstorm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
	]]
	elements={{"tama_elements",{{TAMA_ELEMENT_WATER,1},{TAMA_ELEMENT_MANA,1}}}}
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
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,3},{TAMA_ELEMENT_FIRE,3}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,1))
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,2},{TAMA_ELEMENT_WIND,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,2))
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_REMOVE))
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,3},{TAMA_ELEMENT_EARTH,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,3))
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,4))
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,5))
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local index=e:GetLabel()
	local obj={}
	local broken=false
	if index then obj=tama.get(index) end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,3},{TAMA_ELEMENT_FIRE,3}},obj) then
		if broken then Duel.BreakEffect() end
		local fid=e:GetHandler():GetFieldID()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(0,LOCATION_ONFIELD)
		e1:SetTarget(cm.disable)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_OATH)
		e2:SetTargetRange(0,LOCATION_ONFIELD)
		e2:SetTarget(cm.ftarget)
		e2:SetLabel(fid)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,2},{TAMA_ELEMENT_WIND,2}},obj) then
		if broken then Duel.BreakEffect() end
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_WATER,3},{TAMA_ELEMENT_EARTH,2}},obj) then
		if broken then Duel.BreakEffect() end
		local ct=5
		if tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then ct=7 end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.BreakEffect()
			Duel.ConfirmDecktop(tp,ct)
			local g=Duel.GetDecktopGroup(tp,ct)
			g:Merge(Duel.GetFieldGroup(tp,LOCATION_HAND,0))
			g:Merge(Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil))
			local g1=g:Filter(cm.setfilter3,nil)
			if g1:GetCount()>0 then
				local ct1=Duel.GetLocationCount(tp,LOCATION_SZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=g1:Select(tp,1,ct1,nil)
				Duel.DisableShuffleCheck()
				Duel.SSet(tp,sg:GetFirst())
			end
		end
		broken=true
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.disable(e,c)
	return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function cm.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
--[[
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_WATER,3},{TAMA_ELEMENT_WIND,3}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_WATER,4},{TAMA_ELEMENT_FIRE,4}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_WATER,5},{TAMA_ELEMENT_EARTH,4}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.setfilter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		g:Merge(Duel.GetFieldGroup(tp,LOCATION_HAND,0))
		g:Merge(Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil))
		local g1=g:Filter(cm.setfilter3,nil)
		if g1:GetCount()>0 then
			local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g1:Select(tp,1,ct,nil)
			Duel.DisableShuffleCheck()
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end
]]
