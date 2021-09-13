--小小的愿望
local m=33400127
local cm=_G["c"..m]
function cm.initial_effect(c)
	   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0) 
end
function cm.filter0(c)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.filter1(c)
	return c:IsSetCard(0xc342) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if  Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) then 
	Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
  if  Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) then 
	 local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetValue(1)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	end
		local c=e:GetHandler()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetCondition(cm.xdcon)
		e1:SetOperation(cm.xdop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)	
		e2:SetCountLimit(1)
		e2:SetOperation(cm.op2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	  
end
function cm.filter(c,sp,rp)
	return (c:IsReason(REASON_BATTLE)
		or (rp==sp and c:IsReason(REASON_EFFECT)))  and c:IsPreviousControler(tp) and 
	c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3341,0xc342) and c:IsType(TYPE_MONSTER)
end
function cm.xdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp,rp)	  
end
function cm.refilter(c,sp,rp)
	return (c:IsReason(REASON_BATTLE)
		or (rp==sp and c:IsReason(REASON_EFFECT)))  and c:IsPreviousControler(tp) and 
	c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3341,0xc342) and c:IsType(TYPE_MONSTER)
	and c:IsAbleToRemove()
end
function cm.xdop(e,tp,eg,ep,ev,re,r,rp)
   local rg=eg:Filter(cm.refilter,nil,1-tp,rp)
   if  rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	   Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	   local tc=rg:GetFirst()	 
	   while tc do
	   tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(m,2))
	   tc=tg:GetNext()
	   end
   end 
end

function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:GetFlagEffect(m)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	e:Reset()
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end









