--二次呼吸
function c82567813.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567813)
	e1:SetCost(c82567813.spcost)
	e1:SetTarget(c82567813.sptg)
	e1:SetOperation(c82567813.spop)
	c:RegisterEffect(e1)
end
function c82567813.rfilter(c,e,tp,ft)
	if  c:GetOriginalLevel()>0 
		then return c:IsSetCard(0x825) and c:IsReleasable() and c:IsFaceup() 
					and Duel.IsExistingMatchingCard(c82567813.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetOriginalLevel())
	elseif c:GetOriginalRank()>0 
		then return c:IsSetCard(0x825) and c:IsReleasable() and c:IsFaceup() 
					and Duel.IsExistingMatchingCard(c82567813.spfilterXyz,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetOriginalRank())
	else return c:IsSetCard(0x825) and c:IsReleasable() and c:IsFaceup() 
					and Duel.IsExistingMatchingCard(c82567813.spfilterLink,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLink())
	end
end
function c82567813.spfilter(c,e,tp,mc,lv)
	if c:IsLocation(LOCATION_EXTRA) 
		then return  
		Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLevel(lv) and c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x825)
	else return 
		c:IsLevel(lv) and c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0x825)
	end
end
function c82567813.spfilterXyz(c,e,tp,mc,rk)
	return  Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsRank(rk) and c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	and c:IsSetCard(0x825)
end
function c82567813.spfilterLink(c,e,tp,mc,lk)
	return  Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsLink(lk) and c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	and c:IsSetCard(0x825)
end
function c82567813.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter,1,nil,e,tp,ft) and Duel.IsPlayerCanSpecialSummonCount(tp,1) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c82567813.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mc=e:GetLabelObject()
	if mc:GetOriginalLevel()>0
	  then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local g=Duel.SelectMatchingCard(tp,c82567813.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,mc,mc:GetOriginalLevel())
	  local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc,tc)<=0 then return end
		  if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) ~=0 then
		  local dmg = tc:GetAttack()/2
			if dmg==0 then return end
			Duel.Damage(tp,dmg,REASON_EFFECT)
		  end
	elseif mc:GetOriginalRank()>0
	  then 
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local g=Duel.SelectMatchingCard(tp,c82567813.spfilterXyz,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc,mc:GetOriginalRank())
	  local tc=g:GetFirst()
		   if Duel.GetLocationCountFromEx(tp,tp,mc,tc)<=0 then return end
		   if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) ~=0 and c:IsRelateToEffect(e) then
		   local dmg = tc:GetAttack()/2
		   c:CancelToGrave()
		   Duel.Overlay(tc,Group.FromCards(c))
			  if dmg==0 then return end
			  Duel.Damage(tp,dmg,REASON_EFFECT)
		   end
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local g=Duel.SelectMatchingCard(tp,c82567813.spfilterLink,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc,mc:GetLink())
	  local tc=g:GetFirst()
		   if Duel.GetLocationCountFromEx(tp,tp,mc,tc)<=0 then return end
		   if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) ~=0 then
		   local dmg = tc:GetAttack()/2
			if dmg==0 then return end
			Duel.Damage(tp,dmg,REASON_EFFECT)
		  end
	end
end