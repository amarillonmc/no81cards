--叛骨的命运
local s,id,o=GetID()
--string
s.named_with_Rebellion_Skull=1
--s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelBelow(5)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,2,2,nil)
end
function s.cfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.cfilter,nil,e)
	local tc=g:GetFirst()
	local fidid={}
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e4)
		table.insert(fidid,tc:GetRealFieldID())  
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,0)
		tc=g:GetNext()
	end
	if #fidid>0 then
		--atk limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetLabel(table.unpack(fidid))
		e2:SetValue(s.atlimit)
		Duel.RegisterEffect(e2,tp)
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(s.atklimit)
		e1:SetLabel(table.unpack(fidid))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)]]
	end
end
function s.atklimit(e,c)
	local fidid={e:GetLabel()}
	for _,code in ipairs(fidid) do
		if c:GetRealFieldID()==code then return true end
	end
	return false
end
function s.atlimit(e,c)
	if c:IsFacedown() then return true end
	local fidid={e:GetLabel()}
	for _,code in ipairs(fidid) do
		if c:GetRealFieldID()==code then return false end
	end
	return true
end
