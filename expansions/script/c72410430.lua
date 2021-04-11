--VoiDoll
function c72410430.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410430,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,72410430+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72410430.spcon)
	e1:SetValue(c72410430.spval)
	e1:SetOperation(c72410430.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410431,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,72410431)
	e2:SetOperation(c72410430.backop)
	c:RegisterEffect(e2)
end
function c72410430.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c72410430.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c72410430.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(1-tp))
	end
	return bit.band(zone,0x1f)
end
function c72410430.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c72410430.checkzone(tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c72410430.spval(e,c)
	local tp=c:GetControler()
	local zone=c72410430.checkzone(tp)
	return 0,zone
end
function c72410430.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c72410430.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end

function c72410430.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLocation()==LOCATION_MZONE then
		local seq=Card.GetSequence(c)
		local t=Duel.GetMatchingGroup(c72410430.seqfilter,tp,LOCATION_ONFIELD,0,nil,seq)
		Duel.SendtoDeck(t,nil,2,REASON_EFFECT)
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end