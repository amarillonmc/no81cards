--时穿剑·混沌剑
local m=14000004
local cm=_G["c"..m]
cm.named_with_Chronoblade=1
xpcall(function() require("expansions/script/c14000001") end,function() require("script/c14000001") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.check_link_set_CHRB,1)
	--chrbeffects
	chrb.dire(c)
	chrb.ChronoDamageEffect(c,CATEGORY_ATKCHANGE,EFFECT_FLAG_CARD_TARGET,nil,nil,cm.atktg,cm.atkop,true)
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
function cm.check_link_set_CHRB(c)
	if c:IsLinkType(TYPE_LINK) then return end
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.LoadMetatable(code)
		if mt then
			for str,v in pairs(mt) do   
				if type(str)=="string" and str:find("_Chronoblade") and v then return true end
			end
		end
	end
	return false
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,LOCATION_MZONE)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	chrb.move(e,tp,eg,ep,ev,re,r,rp,true)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end