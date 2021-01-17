--巫恋·瑟谣浮收藏-惑之惧
function c79029365.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),6,2,nil,nil,99)
	c:EnableReviveLimit()  
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029199)
	c:RegisterEffect(e2)  
	--seq
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029365,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029365.seqcost)
	e2:SetTarget(c79029365.seqtg)
	e2:SetOperation(c79029365.seqop)
	c:RegisterEffect(e2)	
	--seq2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029365,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,79029365)
	e2:SetCost(c79029365.seqcost)
	e2:SetTarget(c79029365.seqtg1)
	e2:SetOperation(c79029365.seqop1)
	c:RegisterEffect(e2) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,09029365)
	e4:SetTarget(c79029365.sptg)
	e4:SetOperation(c79029365.spop)
	c:RegisterEffect(e4)  
end
function c79029365.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetFlagEffect(tp,79029365)==0 end
	Duel.RegisterFlagEffect(tp,79029365,0,0,0)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029365.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029365,2))
	local flag=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(flag)
	Duel.Hint(HINT_ZONE,tp,flag)
end
function c79029365.seqop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("今天的运势是......你们真不走运。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029365,5))
	local flag=e:GetLabel()
	local seq=math.log(bit.rshift(flag,16),2)
	if not Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(flag | 0x600060)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e1)
	e2:SetLabel(seq)
	e2:SetCondition(c79029365.adcon)
	e2:SetOperation(c79029365.adop)
	Duel.RegisterEffect(e2,tp)
end
function c79029365.ckfil(c,seq)
	return c:GetSequence()==seq 
end
function c79029365.adcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local tp=e:GetHandler()
	return Duel.IsExistingMatchingCard(c79029365.ckfil,tp,0,LOCATION_MZONE,1,nil,seq)
end
function c79029365.adop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("恶灵，都消散了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029365,6))
	Duel.ResetFlagEffect(tp,79029365)
	e:GetLabelObject():Reset()
	e:Reset() 
end
function c79029365.seqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil) end
end
function c79029365.seqop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029365,3))
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local nseq=math.log(bit.rshift(s,16),2)
	Duel.MoveSequence(g:GetFirst(),nseq)
	Debug.Message("你们回不了家了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029365,4))
	end
end
function c79029365.seqfil(c,e,seq)
	return c:GetSequence()==seq 
	or (c:GetSequence()==5 and e:GetHandler():GetSequence()==1)
	or (c:GetSequence()==6 and e:GetHandler():GetSequence()==3)
end
function c79029365.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetPreviousSequence()
	local cg=Duel.GetMatchingGroup(c79029365.seqfil,tp,0,LOCATION_ONFIELD,nil,e,seq)
	if chk==0 then return cg:GetCount()>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	cg:KeepAlive()
	e:SetLabelObject(cg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79029365.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetPreviousSequence()
	local cg=e:GetLabelObject()
	if cg:GetCount()<=0 then return end
	local g=cg:Select(tp,1,1,nil)
	Duel.Overlay(c,g)
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	Debug.Message("你们的怨恨，我收下了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029365,7))
end



