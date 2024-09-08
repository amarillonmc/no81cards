--[[
～世界纪录仪与Niko～
Solstice Encounter -World Machine and Niko-
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--[[Each time the turn player activates a Spell/Trap Card, their opponent gains 500 LP immediately after it resolves.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--[[During the Standby Phase: The turn player can target 1 Field Spell, Continuous Spell or Continuous Trap in either GY (except "Solstice Encounter -World Machine and Niko-");
	replace this card's ① effect with that target's original effects, also, during the End Phase of this turn, banish that target in the GY.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetRange(LOCATION_FZONE)
	e3:OPT()
	e3:SetLabel(-1)
	e3:SetFunctions(s.effcon,nil,s.efftg,s.effop)
	c:RegisterEffect(e3)
end
--E2
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:HasFlagEffect(id) and rp==Duel.GetTurnPlayer() and re and re:IsActiveType(TYPE_SPELL|TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler()~=c and c:HasFlagEffect(FLAG_ID_CHAINING)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(1-Duel.GetTurnPlayer(),500,REASON_EFFECT)
end

--E3
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.copyfilter(c)
	return (c:IsSpell(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS)) and not c:IsCode(id)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.copyfilter(chkc) end
	if chk==0 then
		return Duel.IsExists(true,s.copyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	Duel.Select(HINTMSG_TARGET,true,tp,s.copyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and s.copyfilter(tc) then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() then
			local prev_cid=e:GetLabel()
			if prev_cid>=0 then
				c:ResetEffect(prev_cid,RESET_COPY)
			end
			local cid=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD)
			if cid>=0 then
				e:SetLabel(cid)
				c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(id,2))
				if not tc:IsOriginalType(TYPE_FIELD) then
					local eset=c:GetEffects()
					for _,ce in ipairs(eset) do
						local type,code,range=ce:GetType(),ce:GetCode(),ce:GetRange()
						if range and range==LOCATION_SZONE then
							ce:SetRange(LOCATION_FZONE)
						end
						if tc:IsOriginalType(TYPE_TRAP) and type==EFFECT_TYPE_QUICK_O and code==EVENT_FREE_CHAIN then
							ce:SetType(EFFECT_TYPE_IGNITION)
						end
					end
				end
			end
		end
		local eid=e:GetFieldID()
		tc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(id,3))
		local e1=Effect.CreateEffect(c)
		e1:Desc(4,id)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_END)
		e1:OPT()
		e1:SetLabel(eid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.rmcon)
		e1:SetOperation(s.rmop)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local eid=e:GetLabel()
	local tc=e:GetLabelObject()
	if not tc or not tc:HasFlagEffectLabel(id+100,eid) then
		e:Reset()
		return false
	end
	return true
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end