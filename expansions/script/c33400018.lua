--时崎狂三 时间王座
function c33400018.initial_effect(c)
	c:EnableCounterPermit(0x34f)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33400018.hspcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(33400018+10000,ACTIVITY_SPSUMMON,c33400018.spfilter)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c33400018.hspcon2)
	e4:SetOperation(c33400018.hspop)
	c:RegisterEffect(e4)  
	 --counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c33400018.adcost)
	e2:SetTarget(c33400018.addct)
	e2:SetOperation(c33400018.addc)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(33400018,ACTIVITY_SPSUMMON,c33400018.counterfilter)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to hand   
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCountLimit(1,33400018)
	e5:SetCondition(aux.bdocon)
	e5:SetTarget(c33400018.thtg)
	e5:SetOperation(c33400018.thop)
	c:RegisterEffect(e5)
end
function c33400018.spfilter(c)
	return not(c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and c:GetSummonType()==SUMMON_TYPE_LINK)
end
function c33400018.spcfilter(c)
	return not(c:IsSetCard(0x3341) and c:IsFaceup())
end
function c33400018.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c33400018.spcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetCustomActivityCount(33400018+10000,tp,ACTIVITY_SPSUMMON)==0
end
function c33400018.hspcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c33400018.hspop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400018.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33400018.splimit2(e,c,tp,sumtp,sumpos)
	return  c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c33400018.counterfilter(c)
	return c:IsSetCard(0x341)
end
function c33400018.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33400018,tp,ACTIVITY_SPSUMMON)==0   end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33400018.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c33400018.splimit(e,c)
	return not c:IsSetCard(0x341)
end
function c33400018.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x34f)
end
function c33400018.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,4)
	end
end
function c33400018.thfilter(c)
	return ((c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x3340)) and c:IsAbleToHand()
end
function c33400018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400018.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33400018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400018.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end