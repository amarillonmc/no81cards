--垣根帝都
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)	  
	--return to hand
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(410904,0))
	e23:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e23:SetCode(EVENT_SPSUMMON_SUCCESS)
	e23:SetCountLimit(1,id+o+EFFECT_COUNT_CODE_DUEL)
	e23:SetCondition(s.spcondition)
	e23:SetOperation(s.rthop)
	c:RegisterEffect(e23) 
	--search
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_BATTLE_DESTROYED)
	e14:SetCountLimit(1,id*10+EFFECT_COUNT_CODE_DUEL)
	e14:SetCondition(s.condition)
	e14:SetOperation(s.operation)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e14:SetCondition(s.condition2)
	c:RegisterEffect(e15)
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_BASE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.atkcon)
	e0:SetValue(s.atkval)
	c:RegisterEffect(e0)
	local e5=e0:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(s.defval)
	c:RegisterEffect(e5)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(s.atkcon)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end
function s.atkcon(e,c)
	return e:GetHandlerPlayer()~=e:GetHandler():GetOwner()
end
function s.atkval(e,c)
	return e:GetHandler():GetTextAttack()*2
end
function s.defval(e,c)
	return e:GetHandler():GetTextDefense()*2
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function s.cfilter(c,ep,tp)
	local reg=c:GetColumnGroup():Filter(Card.IsControler,nil,ep)
	return c:GetColumnGroupCount()>0 and c:IsReleasable(REASON_SPSUMMON) and Duel.GetMZoneCount(ep,c,tp)>0 and not reg:IsExists(s.regfilter,1,nil) 
end
function s.regfilter(c,ep,tp)
	return not c:IsReleasable(REASON_SPSUMMON)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	return #lg>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil,1-tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		local og=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		og:AddCard(tc)
		og:KeepAlive()
		e:SetLabelObject(og)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function s.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	return #lg>0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		local og=tc:GetColumnGroup():Filter(Card.IsControler,nil,tp)
		og:AddCard(tc)
		og:KeepAlive()
		e:SetLabelObject(og)
		return true
	else return false end
end
function s.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,1)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(10)
	c:RegisterEffect(e1)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e13:SetValue(ATTRIBUTE_LIGHT)
	e13:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e13)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.chkcon)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e20:SetCode(EFFECT_DRAW_COUNT)
	e20:SetTargetRange(1,0)
	e20:SetCondition(s.chkcon)
	e20:SetValue(2)
	Duel.RegisterEffect(e20,1-tp)
	--half damage
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CHANGE_DAMAGE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,0)
	e12:SetCondition(s.chkcon)
	e12:SetValue(s.damval)
	Duel.RegisterEffect(e12,tp)
	local e19=Effect.CreateEffect(e:GetHandler())
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_CHANGE_DAMAGE)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e19:SetTargetRange(1,0)
	e19:SetCondition(s.chkcon)
	e19:SetValue(s.damval)
	Duel.RegisterEffect(e19,1-tp)
end
function s.chkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsCode(5012603)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 and Duel.GetFlagEffect(1-tp,id)>0 then return end
	Duel.Hint(HINT_CARD,0,10955021)
	if Duel.GetFlagEffect(tp,id)>0 then
		Duel.ResetFlagEffect(tp,id)
		Duel.RegisterFlagEffect(1-tp,id,0,0,1)
	else
		Duel.ResetFlagEffect(1-tp,id)
		Duel.RegisterFlagEffect(tp,id,0,0,1)
	end
end