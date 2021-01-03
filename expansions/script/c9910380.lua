--虹彩偶像舞台 繁星光影
function c9910380.initial_effect(c)
	aux.AddCodeList(c,9910379)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9910380.activate)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910380.sumlimit)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9910380)
	e3:SetCondition(c9910380.rmcon)
	e3:SetTarget(c9910380.rmtg)
	e3:SetOperation(c9910380.rmop)
	c:RegisterEffect(e3)
end
function c9910380.thfilter(c)
	return c:IsCode(9910379) and c:IsAbleToHand()
end
function c9910380.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910380.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910380,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910380.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c9910380.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5951)
end
function c9910380.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c9910380.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910380.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and rc:GetOriginalLevel()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function c9910380.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not c:IsRelateToEffect(e) or not rc:IsRelateToEffect(re) then return end
	if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
		local lv=rc:GetOriginalLevel()
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-lv*100)
		local fid=c:GetFieldID()
		rc:RegisterFlagEffect(9910380,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910380.retcon)
		e1:SetOperation(c9910380.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910380.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(9910380)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910380.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local op=tc:GetOwner()
	local b1=tc:IsAbleToHand()
	local b2=Duel.GetLocationCount(op,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,op)
	if b2 and (not b1 or Duel.SelectOption(tp,1104,1152)==1) then
		Duel.SpecialSummon(tc,0,tp,op,false,false,POS_FACEUP)
	elseif b1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
