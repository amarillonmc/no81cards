--宇宙战争机器-盖核
local m=13257241
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(cm.eqcon)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	--deck equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.eqop1)
	c:RegisterEffect(e3)
	
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(cm.bgmop)
	c:RegisterEffect(e12)
	eflist={{"deck_equip",e3},{"core_level",1}}
	cm[c]=eflist
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1) end
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)~=0 and Duel.GetCurrentChain()==1
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.eqfilter1(c,ec,code)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec) and not c:IsCode(code)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eq:Filter(Card.IsAbleToDeck,nil)
	if c:IsFacedown() then return end
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		local code=sg:GetFirst():GetCode()
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		local g1=Duel.GetMatchingGroup(cm.eqfilter1,tp,LOCATION_EXTRA,0,nil,c,code)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g1=g1:Select(tp,1,1,nil)
			local tc=g1:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	else
		local g1=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_EXTRA,0,nil,c)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g1=g1:Select(tp,1,1,nil)
			local tc=g1:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	end
end
function cm.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eq:Filter(Card.IsAbleToDeck,nil)
	local code=0
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		code=sg:GetFirst():GetCode()
	end
	local g1=Group.CreateGroup()
	if code>0 then g1=Duel.GetMatchingGroup(cm.eqfilter1,tp,LOCATION_EXTRA,0,nil,c,code)
	else g1=Duel.GetMatchingGroup(cm.eqfilter,tp,LOCATION_EXTRA,0,nil,c) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g1=g1:Select(tp,1,1,nil)
		local tc=g1:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	end
end
