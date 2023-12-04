--壮年登峰
local m=13090013
local cm=_G["c"..m]
function c13090013.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.espcon)
	e2:SetOperation(cm.espop)
	c:RegisterEffect(e2)
 --spsummon
local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,13090013)
	e0:SetCost(cm.srcost)
	e0:SetOperation(cm.srop)
	c:RegisterEffect(e0)
c13090013.star_knight_spsummon_effect=e0
 --p
local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.spcon1)
	e4:SetCost(cm.spcost1)
	e4:SetCountLimit(1,13091113)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
end

function cm.filter3(c)
	return c:IsSummonable(true,nil) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToHand() end,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,nil)
	c:RegisterFlagEffect(13090015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(13090013,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			Duel.Summon(tp,tc,true,nil)
		end
		 local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0)
	e2:SetReset(RESET_EVENT+0xff0000)
	tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0xff0000)
	tc:RegisterEffect(e1)
	local fid=e:GetHandler():GetFieldID()
	tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,fid)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	Duel.RegisterEffect(e1,tp)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m-1)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() end,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil) end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():IsFaceup() and e:GetHandler():GetFlagEffect(13090015)==0
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
   if Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)>0 then
	  local op=0
	  if Duel.GetFlagEffect(tp,m)==0 and Duel.GetFlagEffect(tp,m+1)==0 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	  elseif Duel.GetFlagEffect(tp,m)>0 and Duel.GetFlagEffect(tp,m+1)==0 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	  elseif Duel.GetFlagEffect(tp,m)==0 and Duel.GetFlagEffect(tp,m+1)>0 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	  end
	  if op==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.splimit2)
		Duel.RegisterEffect(e2,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.con)
		e1:SetOperation(cm.damop)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	  else
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetCondition(cm.con)
		e3:SetOperation(cm.rmop)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(tp,m+1,0,0,1)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SKIP_BP)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetCode(EVENT_REMOVE)
		e5:SetOperation(cm.regop)
		e5:SetLabel(tp)
		Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_CANNOT_ACTIVATE)
			e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e6:SetTargetRange(0,1)
			e6:SetValue(cm.actlimit)
			Duel.RegisterEffect(e6,tp)
	 end
   end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetReasonPlayer()==e:GetLabel() then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,2,0,1)
		end
	end
end
function cm.actlimit(e,re,tp)
	return re:GetHandler():GetFlagEffect(m)>0
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetTurnCount(tp)
local tb=Duel.GetTurnCount(1-tp)
local ta=tb+tc
Duel.Damage(1-tp,math.floor(ta*200),REASON_EFFECT)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTurnCount(tp)
	local tb=Duel.GetTurnCount(1-tp)
	local ta=tb+tc
	local tg=Duel.GetDecktopGroup(1-tp,ta)
	if #tg==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function cm.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_DECK)
end
function cm.rmfilter(c,rc)
	return c:IsFaceup() and c:IsAttribute(rc) and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xe08) end,tp,LOCATION_ONFIELD,0,1,nil) and c:IsFaceup() end


function cm.espcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.IsExistingMatchingCard(cm.espfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsFacedown()
end
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
		return c:IsCode(13090012) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter2,tp,LOCATION_ONFIELD,0,1,c)
	else
		return (c:IsCode(13090012) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter2,tp,LOCATION_ONFIELD,0,1,c) and (c:IsLocation(LOCATION_SZONE) and(c:GetSequence()==0 or c:GetSequence()==4)))
		or (c:IsCode(13090012) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.espfilter3,tp,LOCATION_SZONE,0,1,c) and not (c:IsLocation(LOCATION_SZONE) and(c:GetSequence()==0 or c:GetSequence()==4)))
	end
end
function cm.espfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsReleasable()
end
function cm.espfilter3(c)
	return c:IsType(TYPE_SPELL) and c:IsReleasable() and (c:GetSequence()==0 or c:GetSequence()==4)
end