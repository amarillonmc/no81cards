--机略纵横 陈公台
local m=9330020
local cm=_G["c"..m]
Duel.LoadScript("c81000000.lua")
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(3,33200250+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.smtg)
	e1:SetOperation(cm.smop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--atk up1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsCode,33200250))
	e4:SetValue(500)
	c:RegisterEffect(e4)
end

--e1
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()~=tp
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCountLimit(1)   
	e0:SetOperation(cm.smact)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function cm.smact(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) then return end
	Duel.Hint(HINT_CARD,tp,m)
	local token=Duel.CreateToken(tp,33200249)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(6)
		e1:SetReset(RESET_EVENT+0xff0000)
		token:RegisterEffect(e1)
	end 
	Duel.SpecialSummonComplete()
end

--e2 e3
function cm.tgtg(e,c)
	return c:GetSequence()<5
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
