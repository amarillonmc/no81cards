--星绘·启明
function c11185070.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,11185070)
	e1:SetTarget(c11185070.sptg)
	e1:SetOperation(c11185070.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11185070+1+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c11185070.spscon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11185070+2)
	e3:SetCost(c11185070.thcost)
	e3:SetTarget(c11185070.thtg)
	e3:SetOperation(c11185070.thop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e33)
	Duel.AddCustomActivityCounter(11185070,ACTIVITY_SUMMON,c11185070.counterfilter)
	Duel.AddCustomActivityCounter(11185070,ACTIVITY_SPSUMMON,c11185070.counterfilter)
end
function c11185070.counterfilter(c)
	return c:IsSetCard(0x452) or c:IsType(TYPE_TUNER)
end
function c11185070.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x452,1,REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11185070.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsCanRemoveCounter(tp,1,1,0x452,1,REASON_EFFECT) then end
	if not Duel.RemoveCounter(tp,1,1,0x452,1,REASON_EFFECT) then return end
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c11185070.spscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11185070.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11185070,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(11185070,tp,ACTIVITY_SPSUMMON)==0 end
	e:SetLabel(0)
	if Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(11185070,0)) then
		Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
		e:SetLabel(1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11185070.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c11185070.splimit(e,c)
	return not (c:IsSetCard(0x452) or c:IsType(TYPE_TUNER))
end
function c11185070.thfilter(c,e,tp,ck)
	return c:IsSetCard(0x452) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand()
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ck==1 and Duel.GetMZoneCount(tp)>0)
end
function c11185070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ck=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c11185070.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ck) end
end
function c11185070.thop(e,tp,eg,ep,ev,re,r,rp)
	local ck=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11185070.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ck)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ck==0
			or Duel.GetMZoneCount(tp)<0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end