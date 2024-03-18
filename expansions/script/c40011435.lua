--重击炮寨
function c40011435.initial_effect(c)
	c:SetUniqueOnField(1,0,40011435) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c40011435.activate)
	c:RegisterEffect(e1)
end
function c40011435.thfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xf11) and c:IsAbleToHand()
end
function c40011435.tgfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0xf11) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c40011435.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c) and Duel.GetMZoneCount(tp,c)>0 
end 
function c40011435.spfil(c,e,tp,tc) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevel(tc:GetLevel()+2,tc:GetLevel()-2) and c:IsSetCard(0xf11) 
end 
function c40011435.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c40011435.thfilter,tp,LOCATION_DECK,0,nil) 
	local b1=g:GetCount()>0 
	local b2=Duel.IsExistingMatchingCard(c40011435.tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local xtable={}
	if b1 then table.insert(xtable,aux.Stringid(40011435,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(40011435,2)) end 
	local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
	if xtable[op]==aux.Stringid(40011435,1) then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
	if xtable[op]==aux.Stringid(40011435,2) then 
		local tc=Duel.SelectMatchingCard(tp,c40011435.tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst() 
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c40011435.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,tc) then 
			local sc=Duel.SelectMatchingCard(tp,c40011435.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP) 
		end 
	end 
end





