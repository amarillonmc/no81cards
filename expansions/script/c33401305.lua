--D.A.L 精灵的静肃现界
function c33401305.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33401305.target)
	e1:SetOperation(c33401305.activate)
	c:RegisterEffect(e1)
end
function c33401305.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x341) and c:IsLevelBelow(4)
end
function c33401305.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_REMOVED) and c33401305.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33401305.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33401305.activate(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local pd=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then return end
	local g=Duel.SelectMatchingCard(tp,c33401305.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if   Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(33401305,0)) then 
			 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
		else  pd=1
		end 
	end
	 if pd==1 then 
		if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)~=0 then 
		   if  Duel.SelectYesNo(tp,aux.Stringid(33401305,1)) then 
			   Duel.BreakEffect()
			   Duel.Draw(tp,1,REASON_EFFECT)
		   end 
	   end 
	end
end
