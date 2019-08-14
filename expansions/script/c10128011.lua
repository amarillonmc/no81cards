--奇妙物语 奇妙超大卷
function c10128011.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10128011.lfilter,2,2)
	c:EnableReviveLimit() 
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c10128011.reptg)
	e1:SetValue(c10128011.repval)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10128011.reptg2)
	e2:SetOperation(c10128011.repop2)
	c:RegisterEffect(e2)
end
function c10128011.lfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 or bit.band(c:GetOriginalType(),TYPE_TRAP)~=0
end
function c10128011.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE and c10128011.lfilter(c) and c:IsControler(tp)
end
function c10128011.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local count=eg:FilterCount(c10128011.repfilter,nil,tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=count and Duel.GetFlagEffect(tp,10128011)<=0
	end
	if Duel.SelectEffectYesNo(tp,c) then
	   local container=e:GetLabelObject()
	   container:Clear()
	   local g=eg:Filter(c10128011.repfilter,nil,tp)
	   for tc in aux.Next(g) do
		   if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			  local e1=Effect.CreateEffect(c)
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+0x1fc0000)
			  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			  tc:RegisterEffect(e1)
		   end
	   end
	   container:Merge(g)
	   Duel.RegisterFlagEffect(tp,10128011,RESET_PHASE+PHASE_END,0,1)
	   return true
	end
	return false
end
function c10128011.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c10128011.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE end
	return true
end
function c10128011.repop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT+REASON_REDIRECT)~=0 and c:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c10128011.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectEffectYesNo(tp,c) then
	   Duel.Hint(HINT_CARD,0,10128011)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,c10128011.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	   Duel.HintSelection(tg)
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end