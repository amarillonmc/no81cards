--虚构死械-虚影骑士
local m=14001013
local cm=_G["c"..m]
cm.named_with_IDC=1
function cm.initial_effect(c)
	--linksummon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lkfilter,2,3)
	--selecteffects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.efcost)
	e1:SetCondition(cm.efcon)
	e1:SetTarget(cm.eftg)
	e1:SetOperation(cm.efop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.antg)
	c:RegisterEffect(e2)
end
function cm.IDC(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_IDC
end
function cm.lkfilter(c)
	return c:IsRace(RACE_ZOMBIE+RACE_MACHINE) or cm.check_link_set_IDC(c)
end
cm.loaded_metatable_list=cm.loaded_metatable_list or {}
function cm.LoadMetatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=cm.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			cm.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function cm.check_link_set_IDC(c)
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.LoadMetatable(code)
		if mt then
			for str,v in pairs(mt) do   
				if type(str)=="string" and str:find("_IDC") and v then return true end
			end
		end
	end
	return false
end
function cm.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return not c:IsCode(m)
end
function cm.setfilter(c)
	return cm.IDC(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,c)
end
function cm.tdfilter(c)
	return ((cm.IDC(c) and c:IsFaceup()) or (c:IsRace(RACE_ZOMBIE+RACE_MACHINE) and c:IsLocation(LOCATION_GRAVE))) and c:IsAbleToDeck()
end
function cm.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.GetFlagEffect(tp,m+1)==0
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsChainNegatable(ev) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,m+1)==0
	local op,bool=0,false
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		if Duel.NegateActivation(ev) then bool=true end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		if #g>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
			bool=true
		end
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
	if bool==true then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,c)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function cm.antg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end