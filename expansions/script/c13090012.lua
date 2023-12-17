--及冠纵横
local m=13090012
local cm=_G["c"..m]
function c13090012.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,13090012)
	e3:SetTarget(cm.tstg)
	e3:SetOperation(cm.tsop)
	c:RegisterEffect(e3)
c13090012.star_knight_spsummon_effect=e3
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.con)
	e4:SetCountLimit(1,13091012)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,23090012)
	e2:SetCondition(c13090012.espcon)
	e2:SetOperation(c13090012.espop)
	c:RegisterEffect(e2)
Duel.AddCustomActivityCounter(13090012,ACTIVITY_SPSUMMON,c13090012.chainfilter)
end
function c13090012.chainfilter(c)
	 return not c:IsSummonLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE)
	end 
function cm.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(function(c) return Card.IsAbleToRemove end,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetCustomActivityCount(13090012,tp,ACTIVITY_SPSUMMON)==0)or (Duel.IsExistingMatchingCard(function(c) return Card.IsFaceup and c:IsSetCard(0xe08) end,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)) end
end
function cm.penfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xe08)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsFaceup() end
function cm.tsop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(function(c) return Card.IsAbleToRemove end,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetCustomActivityCount(13090012,tp,ACTIVITY_SPSUMMON)==0
	local b2=Duel.IsExistingMatchingCard(function(c) return Card.IsFaceup and c:IsSetCard(0xe08) end,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	   local ta=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	   Duel.Remove(ta,POS_FACEUP,REASON_EFFECT)
	local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(1,0)
			e3:SetTarget(cm.splimit1)
			Duel.RegisterEffect(e3,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e2,tp)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	elseif tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	local ph=Duel.GetCurrentPhase()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SKIP_BP)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2:SetTargetRange(1,0)
		  if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetCondition(cm.skipcon)
			e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.GetDecktopGroup(tp,1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local atpsl=g1:GetFirst()
	local ntpsl=g2:GetFirst()
	Duel.ConfirmCards(1-tp,atpsl)
	Duel.ConfirmCards(tp,atpsl)
	Duel.ConfirmCards(tp,ntpsl)
	Duel.ConfirmCards(1-tp,ntpsl)
	local atplv=atpsl:IsType(TYPE_MONSTER) and atpsl:GetAttack() or 0
	local ntplv=ntpsl:IsType(TYPE_MONSTER) and ntpsl:GetAttack() or 0
	if atplv<=ntplv then
	local tc=Duel.GetAttacker()
	  if tc:IsAbleToDeck() then
	  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	  end
	 end
   end
end
function cm.espcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.espfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsFacedown() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
function cm.espop(e,tp,eg,ep,ev,re,r,rp,c) 
	local g=Duel.GetMatchingGroup(cm.espfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ta=Duel.SelectMatchingCard(tp,cm.espfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	local tc
	if #g<2 or (#g==2 and (ta:IsLocation(LOCATION_SZONE) and (ta:GetSequence()==0 or ta:GetSequence()==4))) then tc=Duel.SelectMatchingCard(tp,cm.espfilter2,tp,LOCATION_ONFIELD,0,1,1,ta):GetFirst()
	else
		tc=Duel.SelectMatchingCard(tp,cm.espfilter3,tp,LOCATION_ONFIELD,0,1,1,ta):GetFirst()
	end
	Duel.Release(Group.FromCards(ta,tc),REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.espfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function cm.espfilter1(c,tp)
	local g=Duel.GetMatchingGroup(cm.espfilter,tp,LOCATION_SZONE,0,nil)
	if #g<2 then
		return c:IsCode(13090011) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter2,tp,LOCATION_ONFIELD,0,1,c)
	else
		return (c:IsCode(13090011) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter2,tp,LOCATION_ONFIELD,0,1,c) and (c:IsLocation(LOCATION_SZONE) and(c:GetSequence()==0 or c:GetSequence()==4)))
		or (c:IsCode(13090011) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter3,tp,LOCATION_SZONE,0,1,c) and not (c:IsLocation(LOCATION_SZONE) and(c:GetSequence()==0 or c:GetSequence()==4)))
	end
end
function cm.espfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsReleasable()
end
function cm.espfilter3(c)
	return c:IsType(TYPE_SPELL) and c:IsReleasable() and (c:GetSequence()==0 or c:GetSequence()==4)
end






















