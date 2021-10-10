--方舟骑士·狮心碎冠 推进之王
function c82567876.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,99,c82567876.lcheck)
	c:EnableReviveLimit()
	--link success
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,82567876)
	e0:SetTarget(c82567876.addct)
	e0:SetOperation(c82567876.addc)
	c:RegisterEffect(e0)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(82567876,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567976)
	e3:SetCost(c82567876.spcost)
	e3:SetCondition(c82567876.spcon)
	e3:SetTarget(c82567876.sptg)
	e3:SetOperation(c82567876.spop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567876.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_BEASTWARRIOR)
end
function c82567876.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x5825)
end
function c82567876.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x5825,2)
	end
end
function c82567876.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x825) and c:IsAbleToGrave()
end
function c82567876.bwfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsFaceup()  
end
function c82567876.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c82567876.bwfilter,c:GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567876.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567876.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c82567876.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c82567876.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c82567876.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5825,1,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5825,1,REASON_COST)
end
function c82567876.spfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsRace(RACE_BEASTWARRIOR) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82567876.spcon(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c82567876.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567876.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c82567876.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,Duel.GetLinkedZone(c:GetControler()))<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567876.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,Duel.GetLinkedZone(c:GetControler()))
	end
end

