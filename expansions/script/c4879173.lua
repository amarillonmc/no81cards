local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,c)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	if #g>0 then 
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(0)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.thop1)
		Duel.RegisterEffect(e1,tp)
--  tc:SetTurnCounter(0)
--  local e1=Effect.CreateEffect(e:GetHandler())
  --		  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  --		  e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
   --   e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
   --   e1:SetLabel(2)
  --		  e1:SetLabelObject(tc)
   --   e1:SetCountLimit(1)
  --		  e1:SetCondition(s.turncon)
  --		  e1:SetOperation(s.turnop)
 --  Duel.RegisterEffect(e1,tp)
 --  local e2=e1:Clone()
 --  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
--  e2:SetCondition(s.retcon)
--  e2:SetOperation(s.retop)
--  Duel.RegisterEffect(e2,tp)

 
	end
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
local ct=e:GetLabel()
	local tc=e:GetLabelObject()
	c:SetTurnCounter(ct+1)
	if ct+1==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else e:SetLabel(ct+1)
	end

end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.cfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xae5d)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
 local rc=sg:GetFirst()
	if sg:GetCount()>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	 local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			e1:SetLabel(0)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetCondition(s.turncon)
			e1:SetOperation(s.turnop)
			Duel.RegisterEffect(e1,tp)
  --	  local e1=Effect.CreateEffect(c)
 --	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  --	  e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
  --	  e1:SetCountLimit(1)
   --	 e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
  --	  e1:SetLabel(0)
  --	  e1:SetLabelObject(rc)
  --	  e1:SetOperation(s.thop)
   --	 Duel.RegisterEffect(e1,tp)
local mt=_G["c"..rc:GetCode()]
		mt[rc]=e1
	rc:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,0,2,aux.Stringid(id,4))
	rc:RegisterFlagEffect(4879171,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,0,2,aux.Stringid(id,4))
	   local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetTargetRange(1,0)
		e2:SetTarget(s.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
--c:RegisterFlagEffect(4879171,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(id,0))
--  c:SetTurnCounter(0)
--  local e1=Effect.CreateEffect(e:GetHandler())
 --  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
 --  e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
 --  e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
 --  e1:SetLabel(0)
 --  e1:SetLabelObject(rc)
 --  e1:SetCountLimit(1)
 --  e1:SetCondition(s.turncon)
  --		  e1:SetOperation(s.turnop)
  --		  Duel.RegisterEffect(e1,tp)
  --		  local e2=e1:Clone()
  --		  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  --		  e2:SetCondition(s.retcon)
  --		  e2:SetOperation(s.retop)
   --   Duel.RegisterEffect(e2,tp)
   --   rc:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_STANDBY,0,2)
	--  s[rc]=e1
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xae5d)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	if ct==e:GetLabel() then
		return true
	end
	return false
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)

	local tc=e:GetLabelObject()
  Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function s.turncon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(1082946)~=0 or tc:GetFlagEffect(4879171)~=0
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
 --   local tc=e:GetLabelObject()
  --  local ct=tc:GetTurnCounter()
  --  ct=ct+1
 --   tc:SetTurnCounter(ct)
 --   if ct>e:GetLabel() then
   --	 tc:ResetFlagEffect(1082946)
--tc:ResetFlagEffect(4879171)
	--	e:Reset()
  --  end
 local tc=e:GetLabelObject()
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct+1==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
 tc:ResetFlagEffect(1082946)
tc:ResetFlagEffect(4879171)
		e:Reset()
	else e:SetLabel(ct+1) end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	return  tc:GetFlagEffectLabel(id)==fid
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct+1==2 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else e:SetLabel(ct+1) end
	
end
function s.cfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xae5d)
end
--function s.thop(e,tp,eg,ep,ev,re,r,rp)
--  local fid,ct=e:GetLabel()
--  local tc=e:GetLabelObject()
--  ct=ct+1
--  e:GetHandler():SetTurnCounter(ct)
--  e:SetLabel(fid,ct)
--  if ct~=2 then return end
--  if tc:GetFlagEffectLabel(id)==fid then
--  Duel.SendtoHand(tc,nil,REASON_EFFECT)
--  Duel.ConfirmCards(1-tp,tc)
--  end
--end