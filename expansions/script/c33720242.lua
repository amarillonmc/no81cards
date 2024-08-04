--[[
爆裂召唤 - 召唤爆裂
Blast Summon - Summon Blast
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Activate by targeting 1 face-up monster on the field and 1 Monster Card in your Spell & Trap Zone; equip this card to the first target.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--[[The equipped monster gains ATK/DEF equal to the original ATK/DEF of the second target, also it gains its effects (if any).]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.tgcon)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(s.defval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.tgeqcon)
	e5:SetOperation(s.copyop)
	c:RegisterEffect(e5)
	--[[During the End Phase: You can send this card and the second target to the GY, and if you do, the monster this card was equipped to gains ATK/DEF equal
	to the original ATK/DEF of the second target, also it gains its effects (if any), and if it does, add this card from the GY to your hand during your next Standby Phase.]]
	local e6=Effect.CreateEffect(c)
	e6:Desc(1,id)
	e6:SetCategory(CATEGORY_TOGRAVE|CATEGORIES_ATKDEF|CATEGORY_TOHAND|CATEGORY_GRAVE_ACTION)
	e6:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE|PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:OPT()
	e6:SetFunctions(nil,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e6)
end

--E1
function s.filter(c)
	return c:IsFaceup() and c:IsInBackrow() and c:IsMonsterCard()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(s.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	local eid=e:GetFieldID()
	Duel.SetTargetParam(eid)
	tc1:RegisterFlagEffect(id,RESET_CHAIN,0,1,eid)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards()
	local eqc=g:Filter(Card.HasFlagEffectLabel,nil,id,Duel.GetTargetParam()):GetFirst()
	local tc=g:Filter(aux.TRUE,eqc):GetFirst()
	if c:IsRelateToChain() and eqc:IsRelateToChain() and eqc:IsFaceup() then
		Duel.Equip(tp,c,eqc)
		if tc:IsRelateToChain() and tc:IsFaceup() then
			c:SetCardTarget(tc)
			tc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD,0,1)
		end
	end
end

--E3
function s.tgcon(e)
	local c=e:GetHandler()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	return tc and tc:HasFlagEffect(id+100)
end
function s.atkval(e,ec)
	local c=e:GetHandler()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	return tc:GetTextAttack()
end
--E4
function s.defval(e,ec)
	local c=e:GetHandler()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	return tc:GetTextDefense()
end
--E5
function s.tgeqcon(e)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	if tc and not tc:IsOriginalType(TYPE_EFFECT) then return end
	local label=e:GetLabel()
	if label~=0 and (c:IsDisabled() or not tc or not tc:HasFlagEffect(id+100)) then
		c:ResetEffect(label,RESET_COPY)
		tc:ResetFlagEffect(id+200)
	elseif tc and tc:HasFlagEffect(id+100) and not tc:HasFlagEffect(id+200) then
		local code=tc:GetOriginalCode()
		local cid=ec:CopyEffect(code,RESET_EVENT|RESETS_STANDARD,1)
		e:SetLabel(cid)
		tc:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(cid)
		e1:SetLabelObject(tc)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(s.resetop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		ec:RegisterEffect(e1,true)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local ec=e:GetHandler()
	local tc=e:GetLabelObject()
	if not ec:GetEquipGroup():IsContains(c) or c:IsFacedown() then
		ec:ResetEffect(e:GetLabel(),RESET_COPY)
		tc:ResetFlagEffect(id+200)
		e:Reset()
	end
end

--E6
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	if chk==0 then
		return ec and tc and tc:HasFlagEffect(id+100) and c:IsAbleToGrave() and tc:IsAbleToGrave()
	end
	local tg=Group.FromCards(ec,tc)
	Duel.SetTargetCard(tg)
	local g=Group.FromCards(c,tc)
	Duel.SetCardOperationInfo(g,CATEGORY_TOGRAVE)
	Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,ec,1,0,0,tc:GetTextAttack())
	if not tc:IsOriginalType(TYPE_LINK) then
		Duel.SetCustomOperationInfo(0,CATEGORY_DEFCHANGE,ec,1,0,0,tc:GetTextDefense())
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=c:GetCardTarget():Filter(Card.HasFlagEffect,nil,id+100):GetFirst()
	if c:IsRelateToChain() and tc and tc:HasFlagEffect(id+100) and tc:IsRelateToChain() then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and ec:IsRelateToChain() and ec:IsFaceup() then
			local rct=Duel.GetNextPhaseCount(PHASE_STANDBY,tp)
			local eid=e:GetFieldID()
			if c:IsLocation(LOCATION_GRAVE) then
				c:RegisterFlagEffect(id+300,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,rct,eid,aux.Stringid(id,2))
			end
			local e1,e2,diffa,diffd=ec:UpdateATKDEF(tc:GetTextAttack(),tc:GetTextDefense(),true,{c,true})
			local check=false
			if tc:IsOriginalType(TYPE_EFFECT) then
				local code=tc:GetOriginalCode()
				local cid=ec:CopyEffect(code,RESET_EVENT|RESETS_STANDARD,1)
				check=true
			end
			if (check or (not ec:IsImmuneToEffect(e1) and diffa>0) or (not ec:IsImmuneToEffect(e2) and diffd>0)) and c:HasFlagEffectLabel(id+300,eid) then
				local e1=Effect.CreateEffect(c)
				e1:Desc(3,id)
				e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
				e1:OPT()
				e1:SetLabel(Duel.GetTurnCount(),eid)
				e1:SetCondition(s.thcon)
				e1:SetOperation(s.thop)
				e1:SetReset(RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,rct)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local turncount=Duel.GetTurnCount()
	local tct,eid=e:GetLabel()
	local c=e:GetHandler()
	if c:HasFlagEffectLabel(nil,id+300,eid) then
		e:Reset()
		return false
	end
	return turncount>tct
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Search(c)
end