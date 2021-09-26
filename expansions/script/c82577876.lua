--异色眼负载龙
function c82577876.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c82577876.lcheck)
	c:EnableReviveLimit()
	--grave pendulum1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82577876)
	e3:SetCondition(c82577876.gpencon1)
	e3:SetTarget(c82577876.gpentg1)
	e3:SetOperation(c82577876.gpenop1)
	c:RegisterEffect(e3) 
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c82577876.descost)
	e4:SetTarget(c82577876.destg)
	e4:SetOperation(c82577876.desop)
	c:RegisterEffect(e4)
end
function c82577876.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c82577876.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:Filter(c82577876.cfilter,nil):GetCount()>0 end
	local thlg=lg:Filter(c82577876.cfilter,nil)
	local g=thlg:Select(tp,1,1,nil)
	Duel.SendtoHand(g,nil,1)
end
function c82577876.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82577876.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c82577876.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x99)
end
function c82577876.apfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c82577876.gravepnfilter(c,csc,apsc,e,tp)
	if c:IsLocation(LOCATION_EXTRA) then 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:GetLevel()>csc and c:GetLevel()<apsc) or (c:GetLevel()<csc and c:GetLevel()>apsc) 
			   or (c:GetRank()>csc and c:GetRank()<apsc) or (c:GetRank()<csc and c:GetRank()>apsc)) and c:IsFaceup() 
			   and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:GetLevel()>csc and c:GetLevel()<apsc) or (c:GetLevel()<csc and c:GetLevel()>apsc) 
			   or (c:GetRank()>csc and c:GetRank()<apsc) or (c:GetRank()<csc and c:GetRank()>apsc))
	end		 
end
function c82577876.gpencon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.IsExistingMatchingCard(c82577876.apfilter,tp,LOCATION_PZONE,0,2,nil) 
			  and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end

function c82577876.gpentg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local pn=Duel.GetMatchingGroup(c82577876.apfilter,tp,LOCATION_PZONE,0,nil)
	local ap1=pn:GetFirst()
	local ap2=pn:GetNext()
	local csc=ap1:GetLeftScale()
	local apsc=ap2:GetLeftScale()
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			  and Duel.IsExistingMatchingCard(c82577876.gravepnfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,csc,apsc,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c82577876.gpenop1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(c82577876.apfilter,tp,LOCATION_PZONE,0,2,nil) then return end
	local pn=Duel.GetMatchingGroup(c82577876.apfilter,tp,LOCATION_PZONE,0,nil)
	local ap1=pn:GetFirst()
	local ap2=pn:GetNext()
	local csc=ap1:GetLeftScale()
	local apsc=ap2:GetLeftScale()
	local zone=Duel.GetLinkedZone(tp)
	local zonecr=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if zonecr<=0 then return end
	if zonecr>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then zonecr=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82577876.gravepnfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,zonecr,nil,csc,apsc,e,tp)
	if g:GetCount()>0 then
	if  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,Duel.GetLinkedZone(c:GetControler()))~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c82577876.splimit2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
end
end
function c82577876.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON)
end