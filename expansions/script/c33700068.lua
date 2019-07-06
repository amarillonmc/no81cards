--动物朋友 长尾虎猫
function c33700068.initial_effect(c)
	c33700068[c]={}
	local effect_list=c33700068[c]
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	effect_list[5]=e1
	e1:SetCondition(c33700068.con)
	e1:SetTarget(c33700068.tg)
	e1:SetOperation(c33700068.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c33700068.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700068.con(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(c33700068.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=5  or e:GetLabel()==33700090
end
function c33700068.filter1(c)
	return c:IsSetCard(0x442)  and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c33700068.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700068.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c33700068.filter1,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c33700068.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33700068.confilter,tp,LOCATION_GRAVE,0,nil) 
   if g:GetClassCount(Card.GetCode)>=6  or e:GetLabel()==33700090  then
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	if Duel.IsExistingMatchingCard(c33700068.filter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then
	if Duel.SelectYesNo(tp,aux.Stringid(33700068,0)) then
	local tg=Duel.SelectMatchingCard(tp,c33700068.filter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,tg)
   Duel.ShuffleHand(tp)
	 local code=tg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
   else
   local tg=Duel.SelectMatchingCard(tp,c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.HintSelection(tg)
	 local code=tg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
end
   elseif  Duel.IsExistingMatchingCard(c33700068.filter1,tp,LOCATION_HAND,0,1,nil) and not Duel.IsExistingMatchingCard(c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then
  local tg=Duel.SelectMatchingCard(tp,c33700068.filter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,tg)
   Duel.ShuffleHand(tp)
	 local code=tg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
   elseif not Duel.IsExistingMatchingCard(c33700068.filter1,tp,LOCATION_HAND,0,1,nil) and  Duel.IsExistingMatchingCard(c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then
   local tg=Duel.SelectMatchingCard(tp,c33700068.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.HintSelection(tg)
	 local code=tg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
end
end
end
   if g:GetClassCount(Card.GetCode)>=13  or e:GetLabel()==33700090  then
	 local tg=Duel.SelectMatchingCard(tp,c33700068.confilter,tp,LOCATION_GRAVE,0,1,1,nil)
	 if tg:GetCount()>0 and  c:IsRelateToEffect(e) and c:IsFaceup() then
		   Duel.HintSelection(tg) 
	local code=tg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
end
end
   if g:GetClassCount(Card.GetCode)>=21 and Duel.IsExistingMatchingCard(c33700068.filter1,tp,LOCATION_DECK,0,1,nil) then
   local cg=Duel.SelectMatchingCard(tp,c33700068.filter1,tp,LOCATION_DECK,0,1,1,nil)
   if cg:GetCount()>0 and  c:IsRelateToEffect(e) and c:IsFaceup() then
	Duel.ConfirmCards(1-tp,cg)
	local code=cg:GetFirst():GetOriginalCode()
	local reset_flag=RESET_EVENT+0x1fe0000
	 c:CopyEffect(code, reset_flag,1)
end
end
end