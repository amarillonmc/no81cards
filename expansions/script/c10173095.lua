--龙魂适能者
function c10173095.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173095,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10173095.seqtg)
	e1:SetOperation(c10173095.seqop)
	c:RegisterEffect(e1)  
	--tk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173095,1))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10173095.tkcon)
	e2:SetTarget(c10173095.tktg)
	e2:SetOperation(c10173095.tkop)
	c:RegisterEffect(e2)
end
function c10173095.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10173095.cfilter,1,nil,tp,e:GetHandler():GetSequence())
end
function c10173095.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,69868556,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10173095.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,69868556,0,0x4011,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,69868556)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c10173095.cfilter(c,tp,rseq)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end 
	if c:IsPreviousLocation(LOCATION_SZONE) then return
	   seq==rseq
	elseif c:IsPreviousLocation(LOCATION_MZONE) then 
	   if rseq==5 then return seq==1 or seq==19
	   elseif rseq==6 then return seq==3 or seq==17
	   else return (seq==rseq-1 or seq==rseq+1) and seq>=0 and seq<=4
	   end
	end
	return false 
end
function c10173095.filter(c,tp)
	local zone=c:GetColumnZone(LOCATION_MZONE,0,0,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 
end
function c10173095.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c10173095.filter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c10173095.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10173095.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp)
end
function c10173095.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local zone=tc:GetColumnZone(LOCATION_MZONE,0,0,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	local flag=bit.bxor(zone,0xff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)  
end
