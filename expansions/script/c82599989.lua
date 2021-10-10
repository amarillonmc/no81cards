--魂钢召还
function c82599989.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c82599989.target)
	e0:SetOperation(c82599989.operation)
	c:RegisterEffect(e0)
	--AddCounter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c82599989.cttg)
	e1:SetOperation(c82599989.ctop)
	c:RegisterEffect(e1)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82599989,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,82599989)
	e4:SetCondition(c82599989.thcon)
	e4:SetTarget(c82599989.thtg)
	e4:SetOperation(c82599989.thop)
	c:RegisterEffect(e4)
end
function c82599989.filter(c,e,tp,lv)
	return c:IsSetCard(0x821) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsLevelBelow(lv)
end
function c82599989.filter2(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x821) and c:IsReleasable() and 
				 Duel.IsExistingMatchingCard(c82599989.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,lv)
end
function c82599989.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return
   Duel.IsExistingMatchingCard(c82599989.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c82599989.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=Duel.SelectMatchingCard(tp,c82599989.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	if not tg or tg:GetCount()==0 then return end
	local mat=tg:GetFirst()
	local lv=mat:GetLevel()
	if mat then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82599989,0))
		local tcc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82599989.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,mat,e,tp,lv)
		local tc=tcc:GetFirst()
		if not tc or tcc:GetCount()==0 then return end
		tc:SetMaterial(tg)
		Duel.ReleaseRitualMaterial(tg)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c82599989.tkfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 
end
function c82599989.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsFaceup() and chkc:GetLevel()>0 and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82599989.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82599989.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82599989.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
end
end
function c82599989.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c82599989.thcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.GetTurnPlayer()==e:GetHandler():GetControler() 
end
function c82599989.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then  return true  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c82599989.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
   Duel.ConfirmCards(1-tp,e:GetHandler())
   Duel.ShuffleHand(tp)
   Duel.ShuffleHand(tp)
end