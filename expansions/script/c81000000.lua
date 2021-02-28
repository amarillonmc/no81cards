--Extra Data of DJ.Tenka
Tenka=Tenka or {}
--Mogami Shizuka, 81018xxx, 0x81b
function Tenka.Shizuka(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	ea:SetValue(1)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	eb:SetRange(LOCATION_MZONE)
	eb:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	eb:SetCountLimit(1)
	eb:SetValue(Tenka.valcon)
	c:RegisterEffect(eb)
end
function Tenka.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
--Kitakami Reika, 81015xxx(81015028~ ), 0x81a
--Reika effect condition
function Tenka.ReikaCon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	for i=0,4 do
		if Duel.GetFieldCard(tp,LOCATION_SZONE,i) then return false end
	end
	return true
end
--koikake atk
function Tenka.KoikakeRitual(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCode(EFFECT_UPDATE_ATTACK)
	ea:SetCondition(Tenka.atkcon)
	ea:SetValue(Tenka.btkval)
	c:RegisterEffect(ea)
end
function Tenka.KoikakeLink(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_UPDATE_ATTACK)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCondition(Tenka.atkcon)
	ea:SetValue(Tenka.atkval)
	c:RegisterEffect(ea)
end
function Tenka.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function Tenka.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:GetLevel()>0
end
function Tenka.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(Tenka.atkfilter,nil)
	return lg:GetSum(Card.GetLevel)*300
end
function Tenka.btkval(e,c)
	return c:GetLevel()*300
end
--kobayashi maid dragon
--advanced summon
function Tenka.MaidDragon(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	ea:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	ea:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FIELD))
	ea:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(ea)
end
--
function Tenka.Asamiya(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,81027000)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetCode(EFFECT_CHANGE_CODE)
	ea:SetRange(LOCATION_MZONE+LOCATION_HAND)
	ea:SetValue(81027000)
	c:RegisterEffect(ea)
end
--
function Tenka.EightOne(c)
	c:EnableReviveLimit()
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCode(EFFECT_SPSUMMON_CONDITION)
	eb:SetValue(aux.FALSE)
	c:RegisterEffect(eb)
end
--
function Tenka.Arisa(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_IMMUNE_EFFECT)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCondition(Tenka.iscon)
	ea:SetValue(Tenka.esfilter)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(81013038,0))
	eb:SetType(EFFECT_TYPE_IGNITION)
	eb:SetProperty(EFFECT_FLAG_CARD_TARGET)
	eb:SetRange(LOCATION_MZONE)
	eb:SetCountLimit(1)
	eb:SetTarget(Tenka.mvtg)
	eb:SetOperation(Tenka.mvop)
	c:RegisterEffect(eb)
end
function Tenka.iscon(e)
	local seq=e:GetHandler():GetSequence()
	return seq==0 or seq==4
end
function Tenka.esfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function Tenka.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81013038,2))
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function Tenka.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
--
function Tenka.ArisaB(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_IMMUNE_EFFECT)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetCondition(Tenka.iscon)
	ea:SetValue(Tenka.esfilter)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(81013038,0))
	eb:SetType(EFFECT_TYPE_QUICK_O)
	eb:SetCode(EVENT_FREE_CHAIN)
	eb:SetProperty(EFFECT_FLAG_CARD_TARGET)
	eb:SetRange(LOCATION_MZONE)
	eb:SetCountLimit(1)
	eb:SetTarget(Tenka.mvtg)
	eb:SetOperation(Tenka.mvop)
	c:RegisterEffect(eb)
end
--
function Tenka.Einstein(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	ea:SetRange(LOCATION_MZONE)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetTargetRange(0,1)
	ea:SetCondition(Tenka.rfcon)
	c:RegisterEffect(ea)
	if not Tenka.global_check then
		Tenka.global_check=true
		local gea=Effect.CreateEffect(c)
		gea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		gea:SetCode(EVENT_DAMAGE)
		gea:SetOperation(Tenka.checkop)
		Duel.RegisterEffect(gea,0)
	end
end
function Tenka.rfcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function Tenka.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,81024000,RESET_PHASE+PHASE_END,0,1)
	end
end
function Tenka.EinMainCon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81024000)~=0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function Tenka.EinBattleCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:IsRelateToBattle()
end
--
function Tenka.PyroLink(c)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	eb:SetValue(1)
	c:RegisterEffect(eb)
end
--
function Tenka.KaedeMusic(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ea:SetCode(EVENT_BE_MATERIAL)
	ea:SetCondition(Tenka.efcon)
	ea:SetOperation(Tenka.efop)
	c:RegisterEffect(ea)
end
function Tenka.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function Tenka.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(Tenka.sumcon)
	e1:SetOperation(Tenka.sumsuc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function Tenka.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function Tenka.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81009011,1))
end
