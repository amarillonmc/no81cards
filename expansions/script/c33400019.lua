--时崎狂三 秘密之爱
function c33400019.initial_effect(c)
	c:EnableCounterPermit(0x34f)	
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400019,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c33400019.adcost)
	e1:SetTarget(c33400019.addct)
	e1:SetOperation(c33400019.addc)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(33400019,ACTIVITY_SPSUMMON,c33400019.counterfilter)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400019,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c33400019.spcost)
	e3:SetCountLimit(1,33400019)
	e3:SetCondition(c33400019.spcd)
	e3:SetTarget(c33400019.sptarget)
	e3:SetOperation(c33400019.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(33400019+20000,ACTIVITY_SPSUMMON,c33400019.spfilter)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c33400019.spcd2)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,33400019)
	e5:SetCost(c33400019.spcost)
	e5:SetTarget(c33400019.thtg)
	e5:SetOperation(c33400019.thop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(33400019+20000,ACTIVITY_SPSUMMON,c33400019.spfilter)
end
function c33400019.counterfilter(c)
	return c:IsSetCard(0x341)
end
function c33400019.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33400019,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400019.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c33400019.splimit(e,c)
	return not c:IsSetCard(0x341)
end
function c33400019.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x34f)
end
function c33400019.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,4)
	end
end
function c33400019.spfilter(c)
	return not(c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and c:GetSummonType()==SUMMON_TYPE_LINK)
end
function c33400019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33400019+20000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400019.splimit2)
	Duel.RegisterEffect(e1,tp)
end
function c33400019.splimit2(e,c,tp,sumtp,sumpos)
	return  c:IsType(TYPE_LINK) and c:IsLinkAbove(3)  and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c33400019.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_ONFIELD) and  c:GetPreviousControler()==tp
end
function c33400019.spcd(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400019.cfilter,1,nil,1-tp) and  re and (re:GetOwner():IsSetCard(0x341) or re:GetOwner():IsSetCard(0x340)) 
end
function c33400019.spcd2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:GetPreviousControler()~=tp
		and  bc:IsSetCard(0x341)
end
function c33400019.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x341) 
end
function c33400019.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c33400019.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33400019.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400019.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33400019.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33400019.rmfilter(c,tp)
	return (c:IsSetCard(0x341) or c:IsSetCard(0x340))  and c:IsAbleToRemove()
end
function c33400019.thfilter(c)
	return (c:IsSetCard(0x3341) or c:IsSetCard(0x3340) or c:IsSetCard(0xc342))  and c:IsAbleToHand()
end
function c33400019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400019.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c33400019.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) 
end
function c33400019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33400019.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c33400019.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end

