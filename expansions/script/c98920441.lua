--铁骑龙 阿普斯维奇
function c98920441.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot SP Sum self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920441,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_SPSUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920441)
	e1:SetCondition(c98920441.condition)
	e1:SetTarget(c98920441.sptg)
	e1:SetOperation(c98920441.spop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920441,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c98920441.destg)
	e3:SetOperation(c98920441.desop)
	c:RegisterEffect(e3)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetValue(c98920441.disval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DISABLE_FIELD)
	e5:SetValue(c98920441.disval1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(c98920441.disval2)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetValue(c98920441.disval3)
	c:RegisterEffect(e7)
end
function c98920441.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return ct1<ct2
end
function c98920441.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920441.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,1-tp,true,false,POS_FACEUP)
	end
end
function c98920441.desfilter(c,seq)
	local seq1=c:GetSequence()
	return math.abs(seq-seq1)<=1
end
function c98920441.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local seq=e:GetHandler():GetSequence()
	local g=Duel.GetMatchingGroup(c98920441.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920441.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c98920441.desfilter,tp,LOCATION_ONFIELD,0,e:GetHandler(),seq)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c98920441.disval(e)
	local c=e:GetHandler()
	local val=0
	local x,zone=Duel.GetMZoneCount(c:GetControler())
	local zoneall=0x1f001f
	local seq=c:GetSequence()
	local seql=seq-1
	local seqr=seq+1
	if seq==0 then seql=5 end
	if seq==4 then seqr=5 end
-- and zone&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)==0
	if seql<5 and val&aux.SequenceToGlobal(c:GetControler(),LOCATION_MZONE,seql)==0 then
		val=val+aux.SequenceToGlobal(c:GetControler(),LOCATION_MZONE,seql)
	end
	if seqr<5 and val&aux.SequenceToGlobal(c:GetControler(),LOCATION_MZONE,seqr)==0 then
		val=val+aux.SequenceToGlobal(c:GetControler(),LOCATION_MZONE,seqr)
	end
	return val
end
function c98920441.disval1(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	local seq=c:GetSequence()
	zone=bit.bor(zone,1<<seq<<8)
	zone=zone<<16
	return zone
end
function c98920441.disval2(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	local seq=c:GetSequence()+1
	local seql=seq+1
	local seqr=seq-1
	zone=bit.bor(zone,1<<seq<<8)
	zone=zone<<16
	return zone
end
function c98920441.disval3(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	local seq=c:GetSequence()-1
	zone=bit.bor(zone,1<<seq<<8)
	zone=zone<<16
	return zone
end