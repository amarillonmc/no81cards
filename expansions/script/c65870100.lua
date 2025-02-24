--Protoss·掠夺者
function c65870100.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65870100+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65870100.spcon)
	e1:SetTarget(c65870100.sptg)
	e1:SetOperation(c65870100.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870100,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c65870100.discost)
	e2:SetCondition(c65870100.chcon)
	e2:SetTarget(c65870100.seqtg)
	e2:SetOperation(c65870100.seqop)
	c:RegisterEffect(e2)
end

function c65870100.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65870100.filter(c)
	return c:IsSetCard(0x3a37) and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function c65870100.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c65870100.filter,tp,LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,2,nil,tp)
end
function c65870100.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65870100.filter,tp,LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.TRUE,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c65870100.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,2,REASON_SPSUMMON)
	g:DeleteGroup()
end

function c65870100.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function c65870100.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c65870100.exmzfilter(c,seq)
	return c:GetSequence()==seq
end
function c65870100.seqfilter(c,seq,tp)
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6 or seq==cseq) then return true end
	if cloc==LOCATION_MZONE and seq>=5 and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c65870100.exmzfilter,tp,0,LOCATION_MZONE,1,nil,seq) then
		return seq==5 and cseq==1 or seq==6 and cseq==3
	end
	return cseq==seq or seq<5 and cseq<5 and cloc==loc and math.abs(cseq-seq)==1
end
function c65870100.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65870100.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65870100.seqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	Duel.Hint(HINT_ZONE,tp,flag)
	local seq=math.log(flag>>16,2)
	local ct=Duel.GetMatchingGroup(c65870100.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,tp)
	Duel.HintSelection(ct)
	Duel.Destroy(ct,REASON_EFFECT)
end