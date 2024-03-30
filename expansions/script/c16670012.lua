--惊喜礼盒
local m=16670012
local cm=_G["c"..m]
cm.loaded_metatable_list={}
cm.loaded_metatable_list2={}
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(3,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
	--
	if not cm.global_check then
		cm.global_check=true
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_PHASE+PHASE_DRAW)
		e11:SetCountLimit(1)
		e11:SetOperation(cm.thop)
	--  Duel.RegisterEffect(e11,0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s=math.random(0,9)
	local s1=s*1000000
	local s2=s1+999999
	for i=1,9999999 do
		local mt1=cm.load_metatable(i)
		if mt1 then
			local token=Duel.CreateToken(tp,l)
			if token and (token:IsType(TYPE_SPELL) or token:IsType(TYPE_TRAP)) then
				table.insert(cm.loaded_metatable_list2,i)
			end
		end
	end
	e:Reset()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return true
	end
	e:SetLabel(0)
	local c=e:GetHandler()
	--[[
	local codelist={}
	local s=math.random(0,9)
	local s1=s*1000000
	local s2=s1+999999
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	]]--
	local codelist2=0
	for i=1,9999999 do
		if codelist2~=0 then
			break
		end
		local l=Duel.GetRandomNumber(1,99999999)--math.random(1,9999999)
		--local l=math.random(1,#cm.loaded_metatable_list2)
		--local mt=cm.load_metatable(l)
		local mt=cm.load_metatable_load(l)
		if mt then
				local token=Duel.CreateToken(tp,l)
				if token and (token:IsType(TYPE_SPELL) or token:IsType(TYPE_TRAP)) and not token:IsType(TYPE_EQUIP)
				and-- not token:IsType(TYPE_CONTINUOUS) and 
				not token:IsType(TYPE_FIELD)
				-- and not token:IsType(TYPE_FIELD) and not token:IsType(TYPE_CONTINUOUS)
				and token:CheckActivateEffect(false,true,false)~=nil
				and token:CheckActivateEffect(false,true,false):GetOperation()~=nil then
					--	table.insert(codelist,i)
					--[[local ab=codelist--cm.get_announce(codelist)
					for i=1,5 do
					local p=math.random(1,#ab)
					table.insert(codelist2,1,ab[p])
				end
				local ac=codelist2[1] ]]--
		--if token:CheckActivateEffect(true,true,false)==nil then
		--	e:SetLabelObject(nil)
		--	else
			--	c:SetHint(CHINT_CARD,l)
				Duel.Hint(HINT_CARD,tp,l)
				Duel.Hint(HINT_CODE,1-tp,l)
				Duel.Hint(HINT_CODE,tp,l)
				local te,ceg,cep,cev,cre,cr,crp=token:CheckActivateEffect(true,true,true)
				e:SetProperty(te:GetProperty())
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,0,0)
				local tg=te:GetTarget()
				if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
				te:SetLabelObject(e:GetLabelObject())
				e:SetLabelObject(te)
				Duel.ClearOperationInfo(0)
				--end
				codelist2=codelist2+1
			end
		end
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local num=c:GetFlagEffect(m)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_SZONE)
	and num<2 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.get_announce(t)
	local rt={t[1],OPCODE_ISCODE}
	for i=2,#t do
		if not t[i] then break end
		table.insert(rt,t[i])
		table.insert(rt,OPCODE_ISCODE)
		table.insert(rt,OPCODE_OR)
	end
	table.insert(rt,TYPE_TRAP)
	table.insert(rt,OPCODE_ISTYPE)
	table.insert(rt,TYPE_SPELL)
	table.insert(rt,OPCODE_ISTYPE)
	table.insert(rt,OPCODE_AND)
	table.insert(rt,OPCODE_AND)
	return rt
end
function cm.load_metatable(code)
	--local m1=_G["c"..code]
	--if m1 then return m1 end
	local m2=cm.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
		--  cm.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end

function cm.load_metatable_load(code)
	local type=Duel.ReadCard(code,CARDDATA_TYPE)
	return type
end
function cm.load_metatable2(code)
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