--元始飞球秘术·爆震
local m=13254040
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
	--blast
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--tornado
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	--flow
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
	]]
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_MANA,1}}}}
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
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,2},{TAMA_ELEMENT_WIND,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,1))
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		local g1=g:Filter(Card.IsCanTurnSet,nil)
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_POSITION))
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,g1:GetCount(),0,0)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_FIRE,2}},obj) then
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(m,2))
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DESTROY))
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_WATER,2}},obj) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
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
	local order_e=false
	local chaos_e=false
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then
		order_e=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
		chaos_e=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,2},{TAMA_ELEMENT_WIND,2}},obj) then
		if broken then Duel.BreakEffect() end
		local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_ONFIELD,nil)
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_SZONE+LOCATION_FZONE)
		g:Sub(sg)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			while tc do
				tc:CancelToGrave()
				tc:GetNext()
			end
			Duel.ChangePosition(sg,POS_FACEDOWN)
			Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_FIRE,2}},obj) then
		if broken then Duel.BreakEffect() end
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if sg:GetCount()==0 then return end
		local limit=5
		if order_e then limit=6 end
		local g=Group.CreateGroup()
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local tc=sg:GetFirst()
			while tc do
				local dg=Group.CreateGroup()
				dg:AddCard(tc)
				Duel.HintSelection(dg)
				local d1=Duel.TossDice(tp,1)
				if d1<limit then
					g:AddCard(tc)
				end
				tc=sg:GetNext()
			end
		else
			while sg:GetCount()>0 do
				local dg=sg:Select(tp,1,1,nil)
				Duel.HintSelection(dg)
				sg:Sub(dg)
				local d1=Duel.TossDice(tp,1)
				if d1<limit then
					g:Merge(dg)
				end
			end
		end
		if g:GetCount()>0 then
			if chaos_e then
				local tc=g:GetFirst()
				while tc do
					tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					tc=g:GetNext()
				end
			end
			local ct=Duel.Destroy(g,REASON_EFFECT)
			if chaos_e then
				local tc=g:GetFirst()
				while tc do
					if tc:GetFlagEffect(m)>0 then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOGRAVE)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOGRAVE)
						tc:RegisterEffect(e2)
					end
					tc=g:GetNext()
				end
			end
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_WATER,2}},obj) and Duel.IsPlayerCanRemove(tp) then
		if broken then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_RULE)~=0 then
			local tc=g:GetFirst()
			if chaos_e then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_REMOVE)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_REMOVE)
				tc:RegisterEffect(e2)
			end
		end
		broken=true
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
--[[
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_EARTH,2},{TAMA_ELEMENT_WIND,2}}
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
	return c:IsAbleToDeck() and c:IsFacedown()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(
			function (e,lp,tp)
				return not e:GetHandler():IsFacedown()
			end
		)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_FIRE,3}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if sg:GetCount()==0 then return end
	local g=Group.CreateGroup()
	if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local tc=sg:GetFirst()
		while tc do
			local dg=Group.CreateGroup()
			dg:AddCard(tc)
			Duel.HintSelection(dg)
			local d1=Duel.TossDice(tp,1)
			if d1<5 then
				g:AddCard(tc)
			end
			tc=sg:GetNext()
		end
	else
		while sg:GetCount()>0 do
			local dg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			sg:Sub(dg)
			local d1=Duel.TossDice(tp,1)
			if d1<5 then
				g:Merge(dg)
			end
		end
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_EARTH,3},{TAMA_ELEMENT_WATER,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function cm.filter2(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
]]
