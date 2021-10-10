--维多利亚·术士干员-爱丽丝
function c79029375.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	c:EnableReviveLimit()
	--double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(c79029375.eacon)
	e1:SetValue(99)
	c:RegisterEffect(e1)
	--ov
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029375)
	e2:SetTarget(c79029375.ovtg)
	e2:SetOperation(c79029375.ovop)
	c:RegisterEffect(e2)
	--attack cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029375.atcon)
	e3:SetCost(c79029375.atcost)
	e3:SetOperation(c79029375.atop)
	c:RegisterEffect(e3)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(0x10000000+79029375)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--Damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c79029375.dacon)
	e5:SetTarget(c79029375.datg)
	e5:SetOperation(c79029375.daop)
	c:RegisterEffect(e5)
end
c79029375.toss_dice=true
function c79029375.eacon(e,c,tp)
	return e:GetHandler():GetOverlayCount()>0 or e:GetHandler():GetFlagEffect(79029375)>0
end
function c79029375.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()==0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function c79029375.ovop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我会带你们到正确的地方。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029375,1))
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)	
	local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,dc,nil)
	Duel.Overlay(c,g)
end
function c79029375.atcon(e,c,tp)
	return e:GetHandler():GetOverlayCount()>0
end
function c79029375.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,79029375)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c79029375.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029375)
	Debug.Message("别催促。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029375,0))
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(79029375,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,0)
end
function c79029375.dacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c79029375.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=e:GetHandler():GetAttackedCount()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(x*1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,x*1000)
end
function c79029375.daop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("不可通过！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029375,2))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end






