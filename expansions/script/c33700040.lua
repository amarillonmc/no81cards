--绝对的妖精 李斯特
function c33700040.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99177923,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33700040.spcon)
	e1:SetCost(c33700040.spcost)
	e1:SetTarget(c33700040.sptg)
	e1:SetOperation(c33700040.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetOperation(c33700040.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33700040.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return ev==ct and eg:IsContains(c) and Duel.GetCurrentPhase()==PHASE_DRAW  
end
function c33700040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33700040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33700040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c33700040.filter(c,e,tp)
   return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700040.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMZoneCount(tp)
	local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g3=Duel.GetMatchingGroup(c33700040.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	 local op=Duel.SelectOption(1-tp,aux.Stringid(33700040,0),aux.Stringid(33700040,1),aux.Stringid(33700040,2))
	if op==0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33700040.thcon)
	e1:SetOperation(c33700040.thop)
	e:GetHandler():RegisterEffect(e1)
	elseif op==1 then
	if not (g1>=g2  and g1<=g3:GetCount()) then return end
	local g=g3:Select(tp,g2,g2,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local fid=e:GetHandler():GetFieldID()
   local tg=g:GetFirst()
	while tg do
		if tg:IsLocation(LOCATION_MZONE) then
	  tg:RegisterFlagEffect(33700040,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tg)
		e1:SetCondition(c33700040.descon)
		e1:SetOperation(c33700040.desop)
		Duel.RegisterEffect(e1,tp)
end
	tg=g:GetNext()
end
	elseif op==2 and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e2)
end
end
function c33700040.desfilter(c,fid)
	return c:GetFlagEffectLabel(33700040)==fid
end
function c33700040.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetFlagEffectLabel(33700040)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
	end
function c33700040.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Destroy(g,REASON_EFFECT)
end
function c33700040.cfilter(c,tp)
	return c:IsControler(tp)
end
 function c33700040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700040.cfilter,1,nil,1-tp) 
end
function c33700040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33700040)
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33700040,3)) then
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
   Duel.SendtoHand(g,nil,REASON_EFFECT)
end
end
end