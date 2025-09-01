--秘林诞地领主 神庙巨人
local s,id,o=GetID()
function c33300762.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xc569),1)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCountLimit(1,id+o*10000)
	e3:SetTarget(s.destg2)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.tgcon)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.confilter(c)
	return c:IsFaceup() and c:IsCode(33300766)
end
function s.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function s.seqfilter(c,mseq,tp)
	local nseq=c:GetSequence()
	if nseq==5 then
	nseq=1
	elseif nseq==6 then 
	nseq=3
	end
	if mseq==5 then
	mseq=1
	elseif mseq==6 then 
	mseq=3
	end
	if c:GetControler()~=tp then
		nseq=math.abs(nseq-4)
	end
	return mseq>nseq and not c:IsLocation(LOCATION_FZONE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local mseq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingTarget(s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,mseq,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,mseq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.seqfilter2(c,mseq,tp)
	local nseq=c:GetSequence()
	if nseq==5 then
	nseq=1
	elseif nseq==6 then 
	nseq=3
	end
	if mseq==5 then
	mseq=1
	elseif mseq==6 then 
	mseq=3
	end
	if c:GetControler()~=tp then
		nseq=math.abs(nseq-4)
	end
	return mseq<nseq and not c:IsLocation(LOCATION_FZONE)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local mseq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingTarget(s.seqfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,mseq,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.seqfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,mseq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.movefil(c)
	return c:IsFaceup() and c:IsSetCard(0xc569)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.movefil,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=tc:GetSequence()
	Duel.MoveSequence(tc,seq)
end