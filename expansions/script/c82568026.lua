--方舟骑士战术-耀刻调和
function c82568026.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568026,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,82568026)
	e2:SetCondition(c82568026.spcon)
	e2:SetTarget(c82568026.sptg)
	e2:SetOperation(c82568026.spop)
	c:RegisterEffect(e2)
	--P set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568026,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,82568026)
	e3:SetCondition(c82568026.spcon)
	e3:SetTarget(c82568026.sttg)
	e3:SetOperation(c82568026.stop)
	c:RegisterEffect(e3)
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568026,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,82568126)
	e4:SetCondition(c82568026.spcon2)
	e4:SetTarget(c82568026.tntg)
	e4:SetOperation(c82568026.tnop)
	c:RegisterEffect(e4)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82568026.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSetCard(0x825)
end
function c82568026.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_PZONE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c82568026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
	and eg:IsExists(c82568026.cfilter,1,nil) and rp==tp
end
function c82568026.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82568026.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_PZONE)
end
function c82568026.spop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568026.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_PZONE) and tc:IsFaceup() then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c82568026.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() 
end
function c82568026.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c82568026.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c82568026.stop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82568026.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c82568026.cfilter2(c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsSetCard(0x825)
end
function c82568026.tnfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and not c:IsType(TYPE_TUNER)
end
function c82568026.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
	and eg:IsExists(c82568026.cfilter2,1,nil) and rp==tp
end
function c82568026.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568026.tnfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	 end
function c82568026.tnop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568026,4))
	local g=Duel.SelectMatchingCard(tp,c82568026.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if  tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	   tc:AddCounter(0x5825,1)
	end
end