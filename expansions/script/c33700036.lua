--Protoform 咲夜
function c33700036.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),5,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(33700036,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700036.thtg)
	e1:SetOperation(c33700036.thop)
	c:RegisterEffect(e1) 
   --pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700036,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33700036.cost)
	e2:SetTarget(c33700036.tg)
	e2:SetOperation(c33700036.op)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e3:SetCost(c33700036.spcost)
	e3:SetTarget(c33700036.sptg)
	e3:SetOperation(c33700036.spop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c33700036.pencon)
	e4:SetTarget(c33700036.pentg)
	e4:SetOperation(c33700036.penop)
	c:RegisterEffect(e4)
end
function c33700036.thfilter(c)
	return  c:IsCode(33700030) and c:IsAbleToHand()
end
function c33700036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33700036.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33700036.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33700036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c33700036.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
	   Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
end
function c33700036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700036.penfilter(c)
	return c:IsSetCard(0x3440) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c33700036.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c33700036.penfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
 end
end
function c33700036.op(e,tp,eg,ep,ev,re,r,rp)
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and  not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c33700036.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(33700036,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c33700036.tdcon)
		e1:SetOperation(c33700036.tdop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		end
end
function c33700036.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetFlagEffectLabel(33700036)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c33700036.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c33700036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,33700036)==0 end
	Duel.RegisterFlagEffect(tp,33700036,RESET_CHAIN,0,1)
end
function c33700036.spfilter(c,g,tp)
	return c:IsCode(33700030) and c:IsFaceup() and c:IsCanBeXyzMaterial(g) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c33700036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700036.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler(),tp) 
	 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	 Duel.ConfirmCards(tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c33700036.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then return end
   local g=Duel.SelectMatchingCard(tp,c33700036.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e:GetHandler(),tp)
   local t=g:GetFirst()
   if t  and not t:IsImmuneToEffect(e) then
		local mg=t:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(e:GetHandler(),mg)
		end
		e:GetHandler():SetMaterial(Group.FromCards(t))
		Duel.Overlay(e:GetHandler(),Group.FromCards(t))
		Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
end
end
function c33700036.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and 
	 c:GetOverlayCount()>0
end
function c33700036.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>0 end
end
function c33700036.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)<=0 then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end