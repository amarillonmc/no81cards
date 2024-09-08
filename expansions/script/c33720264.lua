--[[
纯心歼灭者
Pure Annihilator
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--When this card is activated, you must also Tribute any number of monsters you control (min. 1)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		aux.DummyCost,
		s.target(aux.TributeGlitchyCost(aux.TRUE,1,99,nil,false,false,nil,0,0,0,0,nil,nil,s.relcheck,true)),
		s.operation
	)
	c:RegisterEffect(e1)
	--Equip only to a non-Effect monster with 1000 or less ATK.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	--[[The equipped monster becomes an Effect Monster, and gains this effect.
	● When this card declares an attack: Your opponent must Tribute a number of cards they control, equal to the number of monsters you Tributed to activate "Pure Annihilator".]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:Desc(1,id)
	e5:SetCategory(CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetLabelObject(c)
	e5:SetFunctions(nil,nil,s.reltg,s.relop)
	aux.RegisterGrantEffect(c,LOCATION_SZONE,LOCATION_MZONE,LOCATION_MZONE,s.ecfilter,e5)
end
--E1
function s.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsAttackBelow(1000)
end
function s.relcheck(g,e,tp,mg,c)
	return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,g)
end
function s.target(TributeCost)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
				if chk==0 then
					if e:IsCostChecked() then
						return TributeCost(e,tp,eg,ep,ev,re,r,rp,0)
					else
						return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
					end
				end
				local c=e:GetHandler()
				if e:IsCostChecked() then
					local ct=TributeCost(e,tp,eg,ep,ev,re,r,rp,chk)
					c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,ct)
					c:SetHint(CHINT_NUMBER,ct)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
			end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--E2
function s.eqlimit(e,c)
	return (not c:IsType(TYPE_EFFECT) or c:GetEquipGroup():IsContains(e:GetHandler())) and c:IsAttackBelow(1000)
end

--E5
function s.ecfilter(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
function s.relfilter(c,p)
	return Duel.IsPlayerCanRelease(p,c,REASON_RULE)
end
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetLabelObject()
	if chk==0 then
		return ec:HasFlagEffect(id) and ec:GetFlagEffectLabel(id)>0
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(s.relfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,ec:GetFlagEffectLabel(id),0,0)
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if not ec:HasFlagEffect(id) then return end
	local ct=ec:GetFlagEffectLabel(id)
	if ct==0 then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(s.relfilter,nil,1-tp)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.Release(sg,REASON_RULE,1-tp)
	end
end