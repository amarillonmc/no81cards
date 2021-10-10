--企鹅物流·部署-再临的喧嚣
function c79029369.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029369,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,79029369)
	e2:SetCondition(c79029369.thcon1)
	e2:SetTarget(c79029369.thtg)
	e2:SetOperation(c79029369.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c79029369.thcon2)
	c:RegisterEffect(e3)
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029369,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,09029369)
	e4:SetCondition(c79029369.thcon1)
	e4:SetCost(c79029369.spcost)
	e4:SetTarget(c79029369.sptg)
	e4:SetOperation(c79029369.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c79029369.thcon2)
	c:RegisterEffect(e5)
end
function c79029369.ckfil(c)
	return c:IsSetCard(0x1902) and c:IsType(TYPE_MONSTER)
end
function c79029369.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c79029369.ckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79029369.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029369.ckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79029369.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
end
function c79029369.espfil(c,e,p,code)
	return c:IsCanBeSpecialSummoned(e,0,p,false,false) and not c:IsCode(code)
end
function c79029369.espfil1(c,e,p,code)
	return c:IsCanBeSpecialSummoned(e,0,p,false,false) and not c:IsCode(code) and c:IsSetCard(0xa900)
end
function c79029369.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local p=tc:GetOwner()
	local code=tc:GetCode()
	local xg=Duel.GetMatchingGroup(c79029369.espfil,p,LOCATION_HAND,0,nil,e,p,code)
	local xg1=Duel.GetMatchingGroup(c79029369.espfil1,p,LOCATION_DECK,0,nil,e,p,code)
	if tc:IsSetCard(0xa900) then
	xg:Merge(xg1)
	end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and xg:GetCount()>0 and Duel.GetLocationCount(p,LOCATION_MZONE)>0 and Duel.SelectYesNo(p,aux.Stringid(79029369,0)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=xg:Select(p,1,1,nil)
	Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
	end 
	end 
end
function c79029369.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029369.mtfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c79029369.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029369.mtfil,tp,LOCATION_MZONE+LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function c79029369.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c79029369.mtfil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if mg:GetCount()>=2 then
	getmetatable(e:GetHandler()).announce_filter={0x1902,OPCODE_ISSETCARD}
	table.insert(getmetatable(e:GetHandler()).announce_filter,TYPE_MONSTER)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISTYPE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	table.insert(getmetatable(e:GetHandler()).announce_filter,TYPE_FUSION)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISTYPE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	table.insert(getmetatable(e:GetHandler()).announce_filter,79029277)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_ISCODE)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_NOT)
	table.insert(getmetatable(e:GetHandler()).announce_filter,OPCODE_AND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local tc=Duel.CreateToken(tp,ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local xg=mg:Select(tp,2,2,nil)
	Duel.SendtoGrave(xg,REASON_EFFECT)
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
	tc:SetMaterial(xg)
	Duel.SpecialSummonComplete()
	end
end









