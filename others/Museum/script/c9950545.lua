--fate·清姬
function c9950545.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950545,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9950545.descon)
	e2:SetTarget(c9950545.destg)
	e2:SetOperation(c9950545.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c9950545.spreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950545,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(c9950545.spcon)
	e4:SetTarget(c9950545.sptg)
	e4:SetOperation(c9950545.spop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950545.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950545.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950545,0))
end
function c9950545.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9950545.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9950545.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) and not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	elseif not c:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	else
		local dg=Group.FromCards(c,tc)
		if Duel.Destroy(dg,REASON_EFFECT)==2 and tc:IsLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_GRAVE) then
			Duel.BreakEffect()
			local d=tc:GetAttack()
			if d<0 then d=0 end
			Duel.Damage(1-tp,d,REASON_EFFECT)
		end
	end
end
function c9950545.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT+REASON_DESTROY)~=REASON_EFFECT+REASON_DESTROY then return end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(9950545,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(9950545,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1)
	end
end
function c9950545.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(9950545)>0
end
function c9950545.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(9950545)
end
function c9950545.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
