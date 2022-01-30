--奉神天使 知识
local m=20000369
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(function(e,re,rp,val)
		if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():IsType(TYPE_COUNTER) then
			return 0
		else
			return val
		end
	end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	e3:SetTargetRange(1,0)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFlagEffect(tp,m)>=10
	end)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--[[
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end   
--]]
end
--[[
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:SetLabelObject(Group.CreateGroup()) end
	local g=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5fd2) and tc:GetType()==0x100004
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and bit.band(tc,g)==0 then
			Duel.RegisterFlagEffect(tp,m,0,0,1)
			local code=tc:GetOriginalCode()
			g:AddCard(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetTargetRange(1,1)
			e1:SetDescription(aux.Stringid(code,0))
			Duel.RegisterEffect(e1,tp)
		end
		tc=eg:GetNext()
	end
end
--]]