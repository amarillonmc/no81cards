--法式装甲巡洋舰
local s,id=GetID()
function s.initial_effect(c)
		--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
 --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con1)
	e3:SetValue(1)
	c:RegisterEffect(e3)  
 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con2)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
  --destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,2))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.con4)
	e8:SetTarget(s.destg3)
	e8:SetOperation(s.desop3)
	c:RegisterEffect(e8)
end
function s.tgfilter(c,tp,seq)
	local sseq=c:GetSequence()
	local sg=c:GetColumnGroup()
	if c:IsControler(tp) then 
		if sseq<5 and c:IsLocation(LOCATION_MZONE) then
			return math.abs(sseq-seq)==1
		end
		if (sseq<5 and c:IsLocation(LOCATION_SZONE))  then
			return math.abs(sseq-seq)==0
		end
		if (sseq>=5 and c:IsLocation(LOCATION_MZONE)) then 
			return (sseq==5 and seq==1) or (sseq==6 and seq==3)
		end
	else 
		if c:IsLocation(LOCATION_MZONE) then 
		 return (sseq==3 and seq==5) or (sseq==1 and seq==6)
		end
	end
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local seq=c:GetSequence()
	 local ss=Duel.GetMatchingGroupCount(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and ss>=1
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local seq=c:GetSequence()
	 local ss=Duel.GetMatchingGroupCount(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and ss>=2
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local seq=c:GetSequence()
	local ss=Duel.GetMatchingGroupCount(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return  Duel.IsChainNegatable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and ss>=3
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function s.con4(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local seq=c:GetSequence()
	 local ss=Duel.GetMatchingGroupCount(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and ss>=4
end
function s.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
