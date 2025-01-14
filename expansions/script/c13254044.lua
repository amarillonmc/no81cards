--元始飞球秘术·帷幕
local m=13254044
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
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
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	]]
	elements={{"tama_elements",{{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,1}}}}
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
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,1}},obj) and (tama.tamas_getElementCount(obj,TAMA_ELEMENT_WIND)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_WATER)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_EARTH)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_FIRE))>=1 then
		Duel.SelectOption(tp,aux.Stringid(m,2))
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DRAW))
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_ORDER,2}},obj) then
		Duel.SelectOption(tp,aux.Stringid(m,3))
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local index=e:GetLabel()
	local obj={}
	local broken=false
	if index then obj=tama.get(index) end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,2}},obj) then
		if broken then Duel.BreakEffect() end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		broken=true
	end
	if obj and tama.tamas_isAllElementsNotAbove({{TAMA_ELEMENT_CHAOS,1}},obj) and (tama.tamas_getElementCount(obj,TAMA_ELEMENT_WIND)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_WATER)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_EARTH)+tama.tamas_getElementCount(obj,TAMA_ELEMENT_FIRE))>=1 then
		if broken then Duel.BreakEffect() end
		Duel.Draw(tp,1,REASON_EFFECT)
		broken=true
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--[[
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_CHAOS,3}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_CHAOS,2}}
	local mg=tama.tamas_checkGroupElements((Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,e:GetHandler())),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el) and e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.chainop)
	e3:SetReset(RESET_EVENT+EVENT_CHAIN_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x356) then
		Duel.SetChainLimit(
			function (e,tp,fp)
				return tp==fp
			end
		)
	end
end
]]
