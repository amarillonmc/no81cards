--他们喊着友情啊羁绊啊未来啊什么的就冲上来了
function c11561035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)   
	e1:SetTarget(c11561035.actg) 
	e1:SetOperation(c11561035.acop) 
	c:RegisterEffect(e1) 
end  
function c11561035.spfil(c,e,tp,sc) 
	local rc=sc:GetRace()
	return c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)	
end 
function c11561035.spgck(g,tp) 
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE) 
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) and g:GetCount()>1 then return false end  
	return ft>0 and g:GetCount()<=ft	 
end 
function c11561035.ackfil(c,e,tp) 
	local g=Duel.GetMatchingGroup(c11561035.spfil,tp,0,LOCATION_DECK,nil,e,tp,c)
	return c:IsSummonPlayer(1-tp) and c:IsCanBeEffectTarget(e) and g:CheckSubGroup(c11561035.spgck,1,5,tp)
end 
function c11561035.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(c11561035.ackfil,nil,e,tp) 
	if chk==0 then return g:GetCount()>0 end 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SetTargetCard(sg) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK) 
end 
function c11561035.espfil(c,e,tp,atk)  
	if not (c:GetAttack()>atk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end 
	if c:IsLocation(LOCATION_DECK) then 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	elseif c:IsLocation(LOCATION_EXTRA) then 
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
	else return false end   
end 
function c11561035.acop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c11561035.spfil,tp,0,LOCATION_DECK,nil,e,tp,tc)
	if tc:IsRelateToEffect(e) and g:CheckSubGroup(c11561035.spgck,1,5,tp) then 
		local sg=g:SelectSubGroup(1-tp,c11561035.spgck,false,1,5,tp) 
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP) 
		local atk=sg:GetSum(Card.GetAttack)+tc:GetAttack()  
		if Duel.IsExistingMatchingCard(c11561035.espfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,atk) and Duel.SelectYesNo(tp,aux.Stringid(11561035,0)) then 
			Duel.BreakEffect()  
			local sc=Duel.SelectMatchingCard(tp,c11561035.espfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,atk):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
			local xatk=sc:GetAttack() 
			local dg=Duel.GetMatchingGroup(function(c,xatk) return c:IsFaceup() and c:GetAttack()<xatk end,tp,0,LOCATION_MZONE,nil,xatk) 
			Duel.Destroy(dg,REASON_EFFECT)   
		end 
	end   
end  
 







