--AK-无常的乌有
function c82568062.initial_effect(c)
	 c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	c:SetSPSummonOnce(82568062)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(0)
	c:RegisterEffect(e0)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568062.pcon)
	e2:SetTarget(c82568062.splimit)
	c:RegisterEffect(e2)
	--AddCounter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c82568062.indtg)
	e3:SetOperation(c82568062.indop)
	c:RegisterEffect(e3)  
	--special summon from hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82568062,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c82568062.spcon1)
	e5:SetTarget(c82568062.sptg1)
	e5:SetOperation(c82568062.spop1)
	c:RegisterEffect(e5)
	--coin
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82568062,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c82568062.cointg)
	e6:SetOperation(c82568062.coinop)
	c:RegisterEffect(e6)
end
c82568062.toss_coin=true
function c82568062.spfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c82568062.tgfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsAbleToGrave()
end
function c82568062.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568062.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	and Duel.IsExistingMatchingCard(c82568062.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c82568062.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end	
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c82568062.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local g=Duel.SelectMatchingCard(tp,c82568062.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
	end
end
function c82568062.infilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()  
end
function c82568062.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82568062.infilter,tp,LOCATION_MZONE,0,1,nil) end
	local scl=math.min(12,e:GetHandler():GetLeftScale()+1)
	if e:GetHandler():GetLeftScale()<12 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c82568062.infilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c82568062.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()<=1 then return end
	local scl=1
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_LSCALE)
	e8:SetValue(-scl)
	e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
	if tc:IsRelateToEffect(e) 
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsLocation(LOCATION_MZONE)
  then  tc:AddCounter(0x5825,1)
	end
	
end
function c82568062.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1) and 
	(Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()-Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetLeftScale()>=5 
	 or Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetLeftScale()-Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()>=5)
end
function c82568062.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82568062.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_PENDULUM,tp,tp,true,false,POS_FACEUP)
	c:CompleteProcedure()
end
function c82568062.splimit(e,c,tp,sumtp,sumpos,re)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c82568062.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0 
end