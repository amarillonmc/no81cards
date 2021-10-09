--宝具-灿烂日光午睡酒池肉林
function c9951112.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951112,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c9951112.target)
	e1:SetOperation(c9951112.operation)
	c:RegisterEffect(e1)
	 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951112,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9951112.descon)
	e2:SetTarget(c9951112.destg)
	e2:SetOperation(c9951112.desop)
	c:RegisterEffect(e2)
   --spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9951112.sslimit)
	c:RegisterEffect(e2)
end
function c9951112.filter(c,e,sp)
	return ((c:IsType(TYPE_NORMAL) and c:IsSetCard(0xba5)) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6ba8))) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c9951112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951112.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9951112.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951112.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951112.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x3bd2,0x6ba8)
end
function c9951112.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6ba8) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c9951112.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951112.cfilter,1,nil,tp)
end
function c9951112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9951112.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end