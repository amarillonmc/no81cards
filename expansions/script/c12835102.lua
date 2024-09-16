--侍之魂 仁心丸
function c12835102.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12835102.tg)
	e1:SetOperation(c12835102.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c12835102.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1500)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetCountLimit(1,12835102)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c12835102.con5)
	e5:SetTarget(c12835102.tg5)
	e5:SetOperation(c12835102.op5)
	c:RegisterEffect(e5)	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c12835102.con6)
	e6:SetOperation(c12835102.op6)
	c:RegisterEffect(e6)
	local e62=e6:Clone()
	e62:SetCondition(c12835102.con62)
	e62:SetOperation(c12835102.op62)
	c:RegisterEffect(e62)
end
function c12835102.q(c)
	return c:IsFaceup() and c:IsSetCard(0x3a70) 
end
function c12835102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c12835102.q,tp,4,4,1,nil) end
	Duel.Hint(3,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12835102.q,tp,4,4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c12835102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	Duel.Equip(tp,c,tc)
	end
end
function c12835102.val2(e,c)
	return c:IsSetCard(0x3a70)
end
function c12835102.con5(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)  
end
function c12835102.w(c,e,tp)
	return c:IsCode(12835101) and Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12835102.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12835102.w,tp,1,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,1) 
end
function c12835102.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12835102.w,tp,1,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and  c:IsRelateToEffect(e) and g:GetFirst():IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(12835102,3)) then
	Duel.Equip(tp,c,g:GetFirst())
	end
end
function c12835102.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local seq=tc:GetSequence()
	local tp=tc:GetControler()
	return rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #g>0 and g:IsContains(tc) and c:GetFlagEffect(12835102)==0 and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)))	 
end
function c12835102.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(12835102,1)) then
	Duel.Hint(24,0,aux.Stringid(12835102,0))
	Duel.Hint(HINT_CARD,0,12835114)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not tc then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
	flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
	flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,function(e,tp,eg,ep,ev,re,r,rp) end)
	c:RegisterFlagEffect(12835102,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c12835102.con62(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local seq=tc:GetSequence()
	local tp=tc:GetControler()
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #g>0 and g:IsContains(tc) then return false end
	return rp==1-tp and Duel.GetFlagEffect(tp,12835102)>0 and c:GetFlagEffect(12835102)==0 and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)))	 
end
function c12835102.op62(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(12835102,2)) then
	Duel.ResetFlagEffect(tp,12835102)
	Duel.Hint(24,0,aux.Stringid(12835102,0))
	Duel.Hint(HINT_CARD,0,12835114)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not tc then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
	flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
	flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,function(e,tp,eg,ep,ev,re,r,rp) end)
	c:RegisterFlagEffect(12835102,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end