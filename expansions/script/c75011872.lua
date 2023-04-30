--基格尔德多面体
function c75011872.initial_effect(c)
	c:SetUniqueOnField(1,0,75011872)  
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--rank up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75011872,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetTarget(c75011872.rptg)
	e2:SetOperation(c75011872.rpop)
	c:RegisterEffect(e2)	 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75011872,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c75011872.spcost)
	e3:SetTarget(c75011872.sptg)
	e3:SetOperation(c75011872.spop)
	c:RegisterEffect(e3)
	--limit 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
	return targetp==e:GetHandlerPlayer() end)  
	c:RegisterEffect(e4) 
end 
c75011872.SetCard_TT_JGRD=true 
function c75011872.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and c.SetCard_TT_JGRD and c:IsRankBelow(5) 
		and Duel.IsExistingMatchingCard(c75011872.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c75011872.filter2(c,e,tp,mc)
	return not c:IsCode(mc:GetCode()) and c:IsRankBelow(5) and c.SetCard_TT_JGRD and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c75011872.rptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c75011872.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75011872.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75011872.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75011872.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure()
	end
end
function c75011872.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,LOCATION_MZONE,1,REASON_COST) end 
	Duel.RemoveOverlayCard(tp,LOCATION_MZONE,LOCATION_MZONE,1,1,REASON_COST)
end 
function c75011872.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75011877,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end
function c75011872.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75011877,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,75011877)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end







