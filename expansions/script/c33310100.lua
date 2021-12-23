--可可莉柯特·布兰琪
local m=33310100
local cm=_G["c"..m]
cm.rssetcode="Cochrot"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.bgmop)
	c:RegisterEffect(e0)
	--announce
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(cm.anop)
	c:RegisterEffect(e7)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--deepen damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--act
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetTarget(cm.acttg)
	e6:SetOperation(cm.actop)
	c:RegisterEffect(e6)
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,tp,aux.Stringid(m,0))
end
function cm.anop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,1))
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) then return end
	if #g<=0 then return end
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function cm.actfilter(c,tp)
	return c:IsCode(33310101) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.actfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
end