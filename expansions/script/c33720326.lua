--[[
虚拟YouTuber的离别
VTuber's Departure
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Activate by targeting 1 "VTuber" monster your opponent controls; take control of it.]]
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_CONTROL)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
	e0:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_TARGET)
	e00:SetCode(EFFECT_SET_CONTROL)
	e00:SetRange(LOCATION_SZONE)
	e00:SetValue(function(_e,_c) return _e:GetHandlerPlayer() end)
	c:RegisterEffect(e00)
	--[[You cannot Special Summon monsters, expect by the effect of "VTuber's Departure".]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--[[While you control this face-up card, that monster cannot attack, it cannot be destroyed by battle or card effects, also it cannot be Tributed, or used as a material for a Special Summon from
	the Extra Deck, also it if it would be targeted for an attack, that attack becomes a direct attack instead.]]
	aux.CannotBeEDMaterial(c,nil,LOCATION_SZONE,false,nil,c,nil,false,false,EFFECT_TYPE_TARGET)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TARGET)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TARGET)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetCondition(s.tgcon)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--[[If this card leaves the field, send that monster to the GY, also the Spell & Trap Zone this card was in and the Monster Zone that monster was in cannot be used for the rest of this Duel.]]
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetOperation(s.tgop)
	c:RegisterEffect(e9)
	--[[While you control this face-up card: You can apply 1 of these effects (but you cannot apply that same effect of this card again this turn);
	● Gain LP equal to the targeted monster's ATK.
	● Special Summon 1 monster from your hand, Deck, or from either player's GY, with the same Attribute and lower DEF than the targeted monster.]]
	local e10=Effect.CreateEffect(c)
	e10:Desc(0,id)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_RECOVER)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_SZONE)
	e10:SetFunctions(nil,nil,s.applytg,s.applyop)
	c:RegisterEffect(e10)
end
--E0
function s.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(ARCHE_VTUBER) and (c:IsControler(tp) or c:IsControlerCanBeChanged())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetFirst():IsControler(1-tp) then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() then
		c:SetCardTarget(tc)
	end
end

--E1
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and not se:GetHandler():IsCode(id)
end

--E8
function s.tgcon(e)
	return e:GetHandler():GetFirstCardTarget()~=nil
end

--E9
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if not tc then return end
	local zones=0
	if tc:IsLocation(LOCATION_MZONE) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and not tc:IsOnField() then
		zones=zones|tc:GetPreviousZone(tp)
	end
	zones=zones|c:GetPreviousZone(tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(zones)
	e1:SetOperation(function(_e) return _e:GetLabel() end)
	Duel.RegisterEffect(e1,tp)
end

--E10
function s.spfilter(c,e,tp,attr,def)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(attr) and c:IsDefenseBelow(def)
end
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local b1=tc and not c:HasFlagEffectLabel(id,1) and tc:IsAttackAbove(1)
	local b2=tc and not c:HasFlagEffectLabel(id,2) and tc:IsDefenseAbove(1)
		and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tc:GetAttribute(),tc:GetDefense()-1)
	if chk==0 then
		return not c:HasFlagEffect(id+100) and (b1 or b2)
	end
	c:RegisterFlagEffect(id+100,RESET_CHAIN,0,1)
	Duel.SetTargetCard(tc)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if not tc or not tc:IsRelateToChain() or not tc:IsFaceup() then return end
	local attr,defm1=tc:GetAttribute(),tc:GetDefense()-1
	local b1=not c:HasFlagEffectLabel(id,1) and tc:IsAttackAbove(1)
	local b2=not c:HasFlagEffectLabel(id,2) and tc:IsDefenseAbove(1)
		and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,aux.Necro(s.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,attr,defm1)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,id,1,b1,b2)+1
	if opt==1 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	elseif opt==2 then
		local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,attr,defm1)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,opt,aux.Stringid(id,2+opt))
end