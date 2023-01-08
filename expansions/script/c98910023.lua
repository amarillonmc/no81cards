--无形噬体·虚无形
function c98910023.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,c98910023.mfilter,2,2)
	c:EnableReviveLimit()   
	c:SetSPSummonOnce(98910023)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98910023,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98910023)
	e1:SetCondition(c98910023.thcon)
	e1:SetTarget(c98910023.thtg)
	e1:SetOperation(c98910023.thop)
	c:RegisterEffect(e1)  
--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c98910023.sumlimit)
	c:RegisterEffect(e3)  
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98910023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98910023)   
	e1:SetCondition(c98910023.condition)
	e1:SetTarget(c98910023.sptg)
	e1:SetOperation(c98910023.spop)
	c:RegisterEffect(e1)
end
function c98910023.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLinkRace(RACE_DRAGON)
end
function c98910023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98910023.thfilter(c)
	return c:IsCode(23160024) and c:IsAbleToHand()
end
function c98910023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98910023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98910023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local c=e:GetHandler()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98910023,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1)
	e2:SetValue(c98910023.pendvalue)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)  
  --spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c98910023.sumlimit)
	c:RegisterEffect(e3)
end
function c98910023.pendvalue(e,c)
	return c:IsSetCard(0xe0)
end
function c98910023.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
	and (e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) or e:GetHandler():GetFlagEffect(98910023)~=0)
end
function c98910023.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c98910023.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xe0)
		and Duel.IsExistingMatchingCard(c98910023.stfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,c:GetCode())
end
function c98910023.stfilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xe0) and not c:IsCode(code) and not c:IsForbidden()
end
function c98910023.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c98910023.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98910023.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98910023.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98910023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local code=tc:GetCode()
		local g=Duel.SelectMatchingCard(tp,c98910023.stfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,code)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c98910023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end