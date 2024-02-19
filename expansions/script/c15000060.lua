local m=15000060
local cm=_G["c"..m]
cm.name="色带神的呼唤"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf33))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--roll
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DICE+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.rcon)
	e4:SetOperation(cm.rop)
	c:RegisterEffect(e4)
	--effect gain 1
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.gain2tg)
	c:RegisterEffect(e5)
	--effect gain 2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(cm.gain1tg)
	e6:SetValue(0)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e7)
	--effect gain 3
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_TRIGGER)
	e8:SetValue(1)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(cm.gain3tg)
	c:RegisterEffect(e8)
	--effect gain 4
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_BATTLE_START)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCondition(cm.adcon)
	e9:SetOperation(cm.adop)
	c:RegisterEffect(e9)
end
cm.toss_dice=true
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf33) and c:IsControler(tp)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xf33)
end
function cm.level_or_rank_or_link(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	elseif c:IsType(TYPE_LINK) then return c:GetLink()*2
	else return c:GetLevel() end
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.HintSelection(Group.FromCards(tc))
		local r1,r2=Duel.TossDice(tp,2)
		local rt=r1+r2
		if tc:IsCanAddCounter(0x1f33,1) and rt>cm.level_or_rank_or_link(tc) then
			tc:AddCounter(0x1f33,1)
		end
		tc=g:GetNext()
	end
end
function cm.gain1tg(e,c)
	return c:GetCounter(0x1f33)>=1
end
function cm.gain2tg(e,c)
	return c:GetCounter(0x1f33)>=2
end
function cm.gain3tg(e,c)
	return c:GetCounter(0x1f33)>=3
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	local b1=(tc1 and tc1:GetCounter(0x1f33)>=4)
	local b2=(tc2 and tc2:GetCounter(0x1f33)>=4)
	return b1 or b2
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	local b1=(tc1 and tc1:GetCounter(0x1f33)>=4)
	local b2=(tc2 and tc2:GetCounter(0x1f33)>=4)
	if b1 then
		Duel.Hint(HINT_CARD,1-tp,15000060)
		Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT)
	end
	if b2 then
		Duel.Hint(HINT_CARD,1-tp,15000060)
		Duel.Remove(tc2,POS_FACEDOWN,REASON_EFFECT)
	end
end