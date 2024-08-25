--火山镖弹
function c98920752.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920752,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c98920752.spcon1)
	e1:SetTarget(c98920752.sptg1)
	e1:SetOperation(c98920752.spop1)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920752,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,98920752)
	e4:SetCondition(c98920752.descon)
	e4:SetTarget(c98920752.destg)
	e4:SetOperation(c98920752.desop)
	c:RegisterEffect(e4)	
end
function c98920752.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) 
end
function c98920752.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920752.sfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function c98920752.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g1=tc:GetColumnGroup()
	local g2=Duel.GetMatchingGroup(c98920752.sfilter,0,0,LOCATION_MZONE,tc,tc:GetControler(),tc:GetSequence(),tc:GetLocation())
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if not re then return false end
		local rc=re:GetHandler()
		if rc:IsSetCard(0xb9) and (#g1>0 or #g2>0) then
			local op=0
			if g1:GetCount()>0 and g2:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(98920752,1),aux.Stringid(98920752,2))
			elseif g1:GetCount()>0 then
				op=Duel.SelectOption(tp,aux.Stringid(98920752,1))
			else
				op=Duel.SelectOption(tp,aux.Stringid(98920752,2))+1
			end
			if op==0 then
				Duel.Destroy(g1,REASON_EFFECT)
			else
				Duel.Destroy(g2,REASON_EFFECT)
			end
		end
	end
end
function c98920752.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsSetCard(0xb9)
end
function c98920752.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c98920752.cfilter,1,e:GetHandler(),tp) and not eg:IsContains(e:GetHandler())
end
function c98920752.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920752.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
	end
end