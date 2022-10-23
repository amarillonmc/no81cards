--升阶魔法-连续跃升之力
function c87498770.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DISABLE+CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,87498770+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c87498770.accon)
	e1:SetTarget(c87498770.actg) 
	e1:SetOperation(c87498770.acop) 
	c:RegisterEffect(e1) 
end
function c87498770.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA)   
end 
function c87498770.acfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(nil) and Duel.IsExistingMatchingCard(c87498770.xspfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)  
end 
function c87498770.xspfil1(c,e,tp,mc) 
	return c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRankAbove(mc:GetRank()+1) and Duel.IsExistingMatchingCard(c87498770.xspfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end 
function c87498770.xspfil2(c,e,tp,mc) 
	return c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRank(mc:GetRank()+1,mc:GetRank()+2) and Duel.IsExistingMatchingCard(c87498770.xspfil3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end 
function c87498770.xspfil3(c,e,tp,mc) 
	return c:IsType(TYPE_XYZ) and not c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRank(mc:GetRank()+1,mc:GetRank()+2) 
end 
function c87498770.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c87498770.acfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end  
	local g=Duel.SelectTarget(tp,c87498770.acfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_EXTRA) 
end 
function c87498770.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c87498770.xspfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then 
	local sc1=Duel.SelectMatchingCard(tp,c87498770.xspfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
	local sc2=Duel.SelectMatchingCard(tp,c87498770.xspfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc1):GetFirst() 
	local sc3=Duel.SelectMatchingCard(tp,c87498770.xspfil3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc2):GetFirst() 
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(sc1,mg)
	end
	sc1:SetMaterial(Group.FromCards(tc))
	Duel.Overlay(sc1,Group.FromCards(tc))
	Duel.SpecialSummon(sc1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
	local mg=sc1:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(sc2,mg)
	end
	sc2:SetMaterial(Group.FromCards(sc1))
	Duel.Overlay(sc2,Group.FromCards(sc1))
	Duel.SpecialSummon(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
	local mg=sc2:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(sc3,mg)
	end
	sc3:SetMaterial(Group.FromCards(sc2))
	Duel.Overlay(sc3,Group.FromCards(sc2))
	Duel.SpecialSummon(sc3,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
		local x=math.abs(sc3:GetRank()-sc2:GetRank())+math.abs(sc2:GetRank()-sc1:GetRank()) 
		if x>=2 and Duel.IsPlayerCanDraw(tp,2) then 
		Duel.Draw(tp,2,REASON_EFFECT) 
		end 
		if x>=3 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then 
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil) 
		local tc=g:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end 
		tc=g:GetNext()  
		end 
		end 
		if x>=4 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
		Duel.Destroy(g,REASON_EFFECT) 
		end  
	end 
end 





