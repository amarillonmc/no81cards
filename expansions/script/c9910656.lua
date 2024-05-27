--东方破晓星 耀界星咏号
function c9910656.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910656.sprcon)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910656)
	e2:SetTarget(c9910656.rctg)
	e2:SetOperation(c9910656.rcop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,9910657)
	e3:SetCondition(c9910656.setcon)
	e3:SetTarget(c9910656.settg)
	e3:SetOperation(c9910656.setop)
	c:RegisterEffect(e3)
end
function c9910656.sprfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910656.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c9910656.sprfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9910656.rcfilter(c)
	return c:IsFaceupEx() and c:GetDefense()>0
end
function c9910656.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c9910656.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910656.rcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910656.rcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local def=g:GetFirst():GetDefense()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,def)
end
function c9910656.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
	end
end
function c9910656.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9910656.setfilter(c)
	return c:IsSetCard(0xa952) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910656.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910656.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9910656.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910656.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g:GetFirst())>0
		and c:IsRelateToEffect(e) and c:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(9910656,0)) then
		Duel.BreakEffect()
		local fid=c:GetFieldID()
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)==0 or c:IsReason(REASON_REDIRECT) then return end
		c:RegisterFlagEffect(9910656,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(c9910656.retcon)
		e1:SetOperation(c9910656.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9910656.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(9910656)==e:GetLabel() then
		return Duel.GetCurrentChain()==1
	else
		e:Reset()
		return false
	end
end
function c9910656.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc=tc:GetPreviousLocation()
	if loc==LOCATION_MZONE then
		Duel.ReturnToField(tc)
	end
	if loc==LOCATION_GRAVE then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
	e:Reset()
end
