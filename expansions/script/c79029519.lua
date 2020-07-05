--星遗物的重逢
function c79029519.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029519)
	e1:SetTarget(c79029519.target)
	e1:SetOperation(c79029519.activate)
	c:RegisterEffect(e1)  
	--SynchroSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,79029519)
	e2:SetCost(c79029519.syncost)
	e2:SetTarget(c79029519.syntg)
	e2:SetOperation(c79029519.synop)
	c:RegisterEffect(e2)  
end
function c79029519.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79029519.fil1,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c79029519.fil2,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingMatchingCard(c79029519.fil3,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(c79029519.fil4,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
end
function c79029519.fil1(c)
	return c:IsSetCard(0xfd) and c:IsType(TYPE_MONSTER)
end
function c79029519.fil2(c)
	return c:IsSetCard(0x11b) and c:IsType(TYPE_MONSTER)
end
function c79029519.fil3(c)
	return c:IsSetCard(0xfe) and c:IsType(TYPE_MONSTER)
end
function c79029519.fil4(c,e,tp)
	return (c:IsSetCard(0xfd) or c:IsSetCard(0x11b)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
	or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c79029519.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c79029519.fil1,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c79029519.fil2,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingMatchingCard(c79029519.fil3,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(c79029519.fil4,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
	if b1 then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	if b2 then 
	local x=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(x,REASON_EFFECT)
	end
	if b3 then 
	local tc=Duel.SelectMatchingCard(tp,c79029519.fil4,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029519.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029519.filter1(c,e,tp)
	local lv=c:GetLevel()
	local rg=Duel.GetMatchingGroup(c79029519.filter3,tp,LOCATION_GRAVE,0,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and rg:CheckWithSumEqual(Card.GetLink,lv,1,99)
end
function c79029519.filter3(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemove()
end
function c79029519.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029519.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029519.synop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c79029519.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		local rg=Duel.GetMatchingGroup(c79029519.filter3,tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLink,lv,1,99)
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end




