--他人格 ～怠惰～
local cm,m=GetID()
--lib
AlterEgo=AlterEgo or {}
ae=AlterEgo
function ae.initial(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ae.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(ae.recon)
	e3:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(ae.repcon)
	e4:SetOperation(ae.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,c:GetOriginalCode()+1000)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(ae.sptg)
	e5:SetOperation(ae.spop)
	c:RegisterEffect(e5)
	--ptos
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(ae.ptoscon)
	e6:SetOperation(ae.ptosop)
	c:RegisterEffect(e6)
end
function ae.value(e,c)
	return Duel.GetMatchingGroupCount(ae.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
end
function ae.filter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo and c:IsFaceup()
end
function ae.cfilter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo
end
function ae.recon(e)
	return e:GetHandler():IsLocation(LOCATION_SZONE) and not e:GetHandler():IsLocation(LOCATION_PZONE)
end
function ae.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function ae.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if (num==0 or not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetOwner())) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function ae.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function ae.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ae.ptoscon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function ae.ptosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006111,1))
	end
end
--
cm.AlterEgo=true
function cm.initial_effect(c)
	ae.initial(c)
	--setpos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK)
	e1:SetCondition(function(e) return e:GetHandler():GetFlagEffect(m)>0 end)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(function(e) return e:GetHandler():GetFlagEffect(m)>0 end)
	e2:SetTarget(cm.target)
	c:RegisterEffect(e2)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(function(e) return e:GetHandler():GetFlagEffect(m)>0 end)
	e3:SetTarget(cm.target)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--material
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e8:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e9:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,LOCATION_MZONE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
end
function cm.target(e,c)
	return not ae.filter(c)
end
function cm.efilter(e,te)
	return not ae.cfilter(te:GetOwner())
end