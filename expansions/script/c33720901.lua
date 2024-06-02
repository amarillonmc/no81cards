--[[
哇啊啊啊啊！！
WAAAUGH!!!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Declare the name of another card whose effect was activated in this Chain; negate the effect of all other cards in the same Chain with the same name as the declared one.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Starting from the 5th turn of the Duel and onwards, you can activate this card from your hand.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s.NameTable = {}
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_END)
		ge:SetOperation(s.clear)
		Duel.RegisterEffect(ge,0)
	end
end

function s.clear()
	for k,v in pairs(s.NameTable) do
		s.NameTable[k]=nil
	end
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if #s.NameTable==ev-1 then
		local code,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if code2 and code2~=0 then
			s.NameTable[ev]={code,code2}
		else
			s.NameTable[ev]={code}
		end
	end
	if chk==0 then
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if not te:GetHandler():IsDisabled() and Duel.IsChainDisablable(i) then
				return true
			end
		end
		return false
	end
	
	s.announce_filter={}
	local insertOR=false
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if Duel.IsChainDisablable(i) then
			for _,code in ipairs(s.NameTable[i]) do
				table.insert(s.announce_filter,code)
				table.insert(s.announce_filter,OPCODE_ISCODE)
				if not insertOR then
					insertOR=true
				else
					table.insert(s.announce_filter,OPCODE_OR)
				end
			end
		end
	end
	if #s.announce_filter==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,code,code2=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if code==ac or (code2 and code2==ac) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,#ng,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetTargetParam()
	for i=1,ev do
		local te,code,code2=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if code==ac or (code2 and code2==ac) then
			Duel.NegateEffect(i)
		end
	end
end

--E2
function s.handcon(e)
	return Duel.GetTurnCount()>=5
end