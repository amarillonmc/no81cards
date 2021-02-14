--圣魂之源 奥德亚库修斯
function c30020000.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),5)
	c:EnableReviveLimit() 
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)  
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(c30020000.effectfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(c30020000.effectfilter)
	c:RegisterEffect(e2)
	--change damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--bp
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_BP)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,1)
	c:RegisterEffect(e8) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c30020000.ckop)
	c:RegisterEffect(e1) 
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c30020000.efilter)
	c:RegisterEffect(e4)  
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c30020000.pencon)
	e4:SetOperation(c30020000.penop)
	c:RegisterEffect(e4) 
	--q s t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c30020000.qstconx)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c30020000.qstconx)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c30020000.qstconz)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetCondition(c30020000.qstconz)
	c:RegisterEffect(e1)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_PZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCondition(c30020000.qstcon1)
	e7:SetOperation(c30020000.winop)
	c:RegisterEffect(e7)  
end
function c30020000.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsCode(30020000) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c30020000.ckop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,30020000)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c30020000.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c30020000.pencon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c30020000.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c30020000.spfil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(1-tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(1-tp,1-tp,nil,c)>0)
end
function c30020000.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	local g=Duel.GetMatchingGroup(c30020000.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
	Duel.BreakEffect()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local sg1=Duel.GetMatchingGroup(c30020000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local sg2=Duel.GetMatchingGroup(c30020000.spfil1,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,e,tp)
	if ft1>0 or sg1:GetCount()>0 then 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	msg1=sg1:Select(tp,ft1,ft1,nil)
	end
	if ft2>0 or sg2:GetCount()>0 then 
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	msg2=sg2:Select(1-tp,ft2,ft2,nil)
	end
	local tc1=msg1:GetFirst()
	while tc1 do
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(aux.Stringid(30020000,0))
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c30020000.efilterx)
	tc1:RegisterEffect(e1)
Duel.SpecialSummonComplete()
	tc1=msg1:GetNext() 
	end
	local tc2=msg2:GetFirst()
	while tc2 do
	Duel.SpecialSummonStep(tc2,0,1-tp,1-tp,false,false,POS_FACEUP)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(aux.Stringid(30020000,0))
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c30020000.efilterx)
	tc2:RegisterEffect(e1)
	tc2=msg2:GetNext()
	end
	Duel.SpecialSummonComplete()
	end
end
function c30020000.tdfil(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function c30020000.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c30020000.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c30020000.tdfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,e:GetHandler())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0)
end
function c30020000.efilterx(e,te)
	return te:GetOwner()~=e:GetOwner() and  te:GetOwner()~=e:GetHandler()
end
function c30020000.qstconx(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),30010000) and Duel.GetTurnPlayer()~=tp
end
function c30020000.qstconz(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),30010000) and Duel.GetTurnPlayer()==tp
end
function c30020000.qstcon1(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),30010000) and Duel.GetCurrentPhase()==PHASE_END 
end
function c30020000.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_XIEHUN = 0x1
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp and Duel.GetLP(1-tp)~=0 then	
	Duel.Win(1-tp,WIN_REASON_XIEHUN)
	end
	if Duel.GetTurnPlayer()~=tp and Duel.GetLP(tp)~=0 then	
	Duel.Win(tp,WIN_REASON_XIEHUN)
	end
end