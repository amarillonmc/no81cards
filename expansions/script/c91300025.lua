--飞龙型：猎兽之王
local s,id,o=GetID()
function s.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e8)
	--no battle damage
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--must attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.atktg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e6:SetValue(s.atklimit)
	c:RegisterEffect(e6)
	--cannot be target
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE)
	--e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	--e4:SetRange(LOCATION_MZONE)
	--e4:SetCondition(s.con)
	--e4:SetValue(aux.imval1)
	--c:RegisterEffect(e4)
	--local e5=e4:Clone()
	--e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--e5:SetValue(aux.tgoval)
	--c:RegisterEffect(e5)
	--immune
	--local e6=Effect.CreateEffect(c)
	--e6:SetType(EFFECT_TYPE_SINGLE)
	--e6:SetCode(EFFECT_IMMUNE_EFFECT)
	--e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e6:SetRange(LOCATION_MZONE)
	--e6:SetCondition(s.con)
	--e6:SetValue(s.efilter)
	--c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.discon)
	e7:SetOperation(s.disop)
	c:RegisterEffect(e7)
end
s.hackclad=1
function s.atlimit(e,c)
	return not (_G["c"..c:GetCode()] and _G["c"..c:GetCode()].hackclad)
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) or (_G["c"..te:GetOwner():GetCode()] and _G["c"..te:GetOwner():GetCode()].hackclad) then return false
	end
	return e:GetHandler()~=te:GetOwner()
end
function s.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and _G["c"..c:GetCode()] and _G["c"..c:GetCode()].hackclad
end
function s.atklimit(e,c)
	return c==e:GetHandler()
end
function s.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
--function s.efilter(e,re)
	--return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
--end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and seq==4-aux.MZoneSequence(c:GetSequence())
		and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
		Duel.ChangeTargetPlayer(ev,1-p)
	end
end