--守护天使 急诊天马
function c40009106.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009106,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009106)
	e2:SetCondition(c40009106.sumcon1)
	e2:SetTarget(c40009106.sumtg1)
	e2:SetOperation(c40009106.sumop1)
	c:RegisterEffect(e2)  
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009106,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009106)
	e1:SetCondition(c40009106.sumcon2)
	e1:SetTarget(c40009106.sumtg2)
	e1:SetOperation(c40009106.sumop2)
	c:RegisterEffect(e1) 
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009106,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40009106.sumtg)
	e3:SetOperation(c40009106.sumop)
	c:RegisterEffect(e3)	  
end
function c40009106.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<=10000 or Duel.GetLP(1-tp)<=10000
end
function c40009106.sumfilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function c40009106.sumtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009106.sumfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c40009106.sumop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009106.sumfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c40009106.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())>=10000 or Duel.GetLP(1-tp)>=10000
end
function c40009106.sumfilter2(c)
	return ((c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) or (c:IsSetCard(0xf27) and c:IsLocation(LOCATION_DECK))) and c:IsSummonable(true,nil)
end
function c40009106.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009106.sumfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c40009106.sumop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009106.sumfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c40009106.sumfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function c40009106.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009106.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c40009106.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009106.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end 