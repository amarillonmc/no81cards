--異統叱霓
function c79008172.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c79008172.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79008172)
	e1:SetTarget(c79008172.target)
	e1:SetOperation(c79008172.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19008172)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79008172.sptg)
	e2:SetOperation(c79008172.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(79008172,ACTIVITY_SPSUMMON,c79008172.counterfilter)
end
function c79008172.counterfilter(c)
	return not c:IsType(TYPE_FUSION)
end
function c79008172.xfilter1(c)
	return c:IsFaceup() and (c:IsCode(6205579) or c:GetMaterial():IsExists(Card.IsCode,1,nil,6205579))
end
function c79008172.handcon(e)
	return Duel.IsExistingMatchingCard(c79008172.xfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c79008172.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c79008172.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79008172.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetChainLimit(c79008172.chlimit)
end
function c79008172.chlimit(e,ep,tp)
	return tp==ep
end
function c79008172.xfilter2(c)
	return c:IsFaceup() and (c:IsRace(RACE_INSECT) or c:GetMaterial():IsExists(Card.IsRace,1,nil,RACE_INSECT))
end
function c79008172.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79008172.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.IsExistingMatchingCard(c79008172.xfilter2,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79008172,0)) then
	local dg=Duel.GetMatchingGroup(c79008172.xfilter2,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c79008172.spfil1(c,e,tp)
	return c:IsRace(RACE_FAIRY+RACE_WINDBEAST+RACE_BEASTWARRIOR+RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(c79008172.spfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c79008172.spfil2(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsRank(4) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c79008172.spfil3(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsRank(7) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c79008172.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79008172.spfil1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79008172.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79008172.spfil1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 
	then 
	local tc=g:GetFirst()
	Duel.BreakEffect()
	local sc=Duel.SelectMatchingCard(tp,c79008172.spfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()   
	if sc==nil then return end 
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	if Duel.GetCustomActivityCount(79008172,1-tp,ACTIVITY_SPSUMMON)~=0 and sc:IsCanOverlay() and Duel.IsExistingMatchingCard(c79008172.spfil3,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79008172,1)) then
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2)) 
	local xc1=Duel.SelectMatchingCard(tp,c79008172.spfil3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local mg=sc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(xc1,mg)
		end
		xc1:SetMaterial(Group.FromCards(sc))
		Duel.Overlay(xc1,Group.FromCards(sc))
		Duel.SpecialSummon(xc1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xc1:CompleteProcedure()
	if xc1:IsCanOverlay() and Duel.IsExistingMatchingCard(c79008172.spfil3,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79008172,1)) then
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2)) 
	local xc2=Duel.SelectMatchingCard(tp,c79008172.spfil3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local mg=xc1:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(xc2,mg)
		end
		xc2:SetMaterial(Group.FromCards(xc1))
		Duel.Overlay(xc2,Group.FromCards(xc1))
		Duel.SpecialSummon(xc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xc2:CompleteProcedure()
	if sc:IsCanOverlay() and Duel.IsExistingMatchingCard(c79008172.spfil3,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79008172,1)) then
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2)) 
	local xc3=Duel.SelectMatchingCard(tp,c79008172.spfil3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local mg=xc2:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(xc3,mg)
		end
		xc3:SetMaterial(Group.FromCards(xc2))
		Duel.Overlay(xc3,Group.FromCards(xc2))
		Duel.SpecialSummon(xc3,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xc3:CompleteProcedure() 
	end 
	end 
	end
	end 
end
 
