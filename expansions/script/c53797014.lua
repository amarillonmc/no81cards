local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_TO_GRAVE)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function s.spfilter(c,e)
	return c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(s.cfilter,nil,tp):Filter(s.spfilter,nil,e)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return #mg>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and e:GetHandler():GetLeftScale()<12 end
	local g=mg
	if #mg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		g=mg:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if c:IsRelateToEffect(e) and c:GetLeftScale()<12 then
			local ct=math.min(tc:GetOriginalLevel(),12-c:GetLeftScale())
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			c:RegisterEffect(e2)
		end
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		e3:SetCountLimit(1)
		e3:SetLabel(fid,Duel.GetTurnCount())
		e3:SetLabelObject(tc)
		e3:SetCondition(s.descon)
		e3:SetOperation(s.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=ct and tc:GetFlagEffectLabel(id)==fid
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
