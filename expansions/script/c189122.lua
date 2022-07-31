--皓端之机界骑士
function c189122.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,189122+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c189122.hspcon)
	e1:SetValue(c189122.hspval)
	c:RegisterEffect(e1) 
	--zone and set 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,289122)
	e2:SetTarget(c189122.zstg) 
	e2:SetOperation(c189122.zsop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3)
end
function c189122.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c189122.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c189122.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c189122.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c189122.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end 
function c189122.stfil(c) 
	return c:IsSetCard(0xfe) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end 
function c189122.zstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end 
end 
function c189122.zsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	local g=Duel.GetMatchingGroup(c189122.stfil,tp,LOCATION_DECK,0,nil) 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	Duel.MoveSequence(c,seq)	 
	if Duel.IsExistingMatchingCard(c189122.stfil,tp,LOCATION_DECK,0,1,nil) and Duel.CheckLocation(tp,LOCATION_SZONE,seq) and Duel.SelectYesNo(tp,aux.Stringid(189122,0)) then  
	local tc=Duel.SelectMatchingCard(tp,c189122.stfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	local cseq=c:GetSequence() 
	local s=0
	if cseq==0 then s=1  
	elseif cseq==1 then s=2  
	elseif cseq==2 then s=4  
	elseif cseq==3 then s=8  
	else s=16 end 
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false,s) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.ConfirmCards(1-tp,tc)
	Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
	end 
	end 
end 










