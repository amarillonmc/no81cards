--翱翔之折纸使
function c9910034.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910034.condtion)
	e1:SetValue(c9910034.valcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910034.condtion)
	e2:SetValue(c9910034.efilter)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910034,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910034.thcon)
	e3:SetTarget(c9910034.thtg)
	e3:SetOperation(c9910034.thop)
	c:RegisterEffect(e3)
end
function c9910034.mfilter(c)
	return not c:IsType(TYPE_PENDULUM)
end
function c9910034.condtion(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and mg:GetCount()>0 and not mg:IsExists(c9910034.mfilter,1,nil)
end
function c9910034.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c9910034.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c9910034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c9910034.thfilter1(c,g)
	return c:IsAbleToHand() and g:IsContains(c)
end
function c9910034.thfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3950) and c:IsAbleToHand()
end
function c9910034.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	local tg=c:GetColumnGroup()
	tg:AddCard(c)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c9910034.thfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tg)
	g:Merge(g1)
	local g2=Duel.GetMatchingGroup(c9910034.thfilter2,tp,LOCATION_EXTRA,0,nil)
	g:Merge(g2)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if g1:IsContains(tc) then Duel.HintSelection(sg) end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		if g2:IsContains(tc) then Duel.ConfirmCards(1-tp,sg) end
	end
end
