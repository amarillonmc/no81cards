--无序的终点
function c60002397.initial_effect(c)
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetCondition(cm.spcon) 
	e2:SetTarget(cm.sptg) 
	e2:SetOperation(cm.spop) 
	c:RegisterEffect(e2) 
end
function cm.sckfil(c,tp,e) 
	return c:IsType(TYPE_RITUAL) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(cm.sckfil,1,nil,tp,e) 
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
end 
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local sg=eg:Filter(cm.sckfil,nil,tp,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and cg:IsExists(Card.IsRace,1,nil,RACE_FAIRY) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
		local rmg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_DECK,nil,TYPE_FIELD)
		Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)
	end 
end 