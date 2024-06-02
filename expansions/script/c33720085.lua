--[[
Niko ～自由～
Niko - Happily Ever After -
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Special Summon monsters, also send all Special Summoned monsters you control to the GY. This effect cannot be negated.
	local p0=Effect.CreateEffect(c)
	p0:SetType(EFFECT_TYPE_FIELD)
	p0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	p0:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	p0:SetRange(LOCATION_PZONE)
	p0:SetTargetRange(1,0)
	c:RegisterEffect(p0)
	local p1=Effect.CreateEffect(c)
	p1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	p1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCode(EVENT_ADJUST)
	p1:SetOperation(s.adjustop)
	c:RegisterEffect(p1)
	--Cannot be destroyed, except by its own effect.
	local p2=Effect.CreateEffect(c)
	p2:SetType(EFFECT_TYPE_SINGLE)
	p2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	p2:SetCode(EFFECT_INDESTRUCTABLE)
	p2:SetRange(LOCATION_PZONE)
	p2:SetValue(s.efilter)
	c:RegisterEffect(p2)
	--If this card is placed in your Pendulum Zone: Banish 1 card from your Deck, face-down.
	local p3=Effect.CreateEffect(c)
	p3:Desc(0,id)
	p3:SetCategory(CATEGORY_REMOVE)
	p3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	p3:SetCode(EVENT_MOVE)
	p3:SetCondition(s.rmcon)
	p3:SetTarget(s.rmtg)
	p3:SetOperation(s.rmop)
	c:RegisterEffect(p3)
	--[[If a card(s) you control would be destroyed by battle or by an opponent's card effect, you can destroy this card instead, and if you do,
	add the card banished by this card's effect to your hand.]]
	local p4=Effect.CreateEffect(c)
	p4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	p4:SetCode(EFFECT_DESTROY_REPLACE)
	p4:SetRange(LOCATION_PZONE)
	p4:SetTarget(s.reptg)
	p4:SetValue(s.repval)
	p4:SetOperation(s.repop)
	c:RegisterEffect(p4)
end
--P1
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(Card.IsSpecialSummoned,tp,LOCATION_MZONE,0,nil)
	local readjust=false
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE,tp)
		readjust=true
	end
	if readjust then Duel.Readjust() end
end

--P2
function s.efilter(e,re,r,rp)
	return r&REASON_EFFECT==0 or re:GetOwner()~=e:GetOwner()
end

--P3
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_PZONE) and (not c:IsPreviousLocation(LOCATION_PZONE) or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousSequence()~=c:GetSequence())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveFacedown,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveFacedown,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 and tc:IsBanished(POS_FACEDOWN) and aux.BecauseOfThisEffect(e)(tc) then
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,fid)
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,1))
	end
end

--P4
function s.filter(c,tp)
	return c:IsControler(tp) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function s.thfilter(c,fid)
	return c:HasFlagEffectLabel(id,fid) and c:IsAbleToHand()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(s.filter,1,c,tp) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
			and c:HasFlagEffect(id) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetFlagEffectLabel(id))
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.filter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFlagEffectLabel(id)
	Duel.Destroy(c,REASON_EFFECT|REASON_REPLACE)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil,fid)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end