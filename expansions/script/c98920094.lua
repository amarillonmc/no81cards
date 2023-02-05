--炎王兽 辛玛
function c98920094.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920094,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c98920094.spcon)
	e1:SetTarget(c98920094.sptg)
	e1:SetOperation(c98920094.spop)
	c:RegisterEffect(e1)	
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920094,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98920094)
	e3:SetTarget(c98920094.destg)
	e3:SetCondition(c98920094.descon)
	e3:SetOperation(c98920094.desop)
	c:RegisterEffect(e3)
end
function c98920094.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsReason(REASON_EFFECT) and c:IsSetCard(0x81)
end
function c98920094.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920094.cfilter,1,nil,tp)
end
function c98920094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920094.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920094.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c98920094.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920094.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920094.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()<1 then return end			 
		if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then				
			   local sg2=Duel.GetOperatedGroup()
				local fid=e:GetHandler():GetFieldID()
				local tc=sg2:GetFirst()
				while tc do
					tc:RegisterFlagEffect(98920094,RESET_EVENT+RESETS_STANDARD,0,0,fid)
					tc=sg2:GetNext()
				end
				sg2:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(sg2)
				e1:SetCondition(c98920094.descon2)
				e1:SetOperation(c98920094.desop2)
				Duel.RegisterEffect(e1,tp)
		end
	Duel.SpecialSummonComplete()
	end
end
function c98920094.spfilter(c,e,tp)
	return c:IsSetCard(0x81) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920094.desfilter2(c,fid)
	return c:GetFlagEffectLabel(98920094)==fid
end
function c98920094.descon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c98920094.desfilter2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c98920094.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c98920094.desfilter2,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end