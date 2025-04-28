--苍晓交辉
function c75030028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,75030028)
	e1:SetCost(c75030028.cost)
	e1:SetTarget(c75030028.target)
	e1:SetOperation(c75030028.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetTarget(c75030028.reptg)
	e2:SetValue(c75030028.repval)
	e2:SetOperation(c75030028.repop)
	c:RegisterEffect(e2)
end
function c75030028.pbfil(c) 
	return not c:IsPublic() and c:IsRace(RACE_PYRO) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end 
function c75030028.cost(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return true end 
	e:SetLabel(0) 
	if Duel.IsExistingMatchingCard(c75030028.pbfil,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75030028,0)) then 
		local pg=Duel.SelectMatchingCard(tp,c75030028.pbfil,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,pg) 
		Duel.ShuffleHand(tp)
		e:SetLabel(1) 
	end 
end  
function c75030028.spfil(c,e,tp)
	return c:IsSetCard(0x5751,0x6751) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75030028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75030028.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75030028.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x5751,0x6751) and c:IsType(TYPE_MONSTER) 
end 
function c75030028.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75030028.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c75030028.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75030028,1)) then
		local sg=Duel.SelectMatchingCard(tp,c75030028.thfil,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end
end
function c75030028.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5751,0x6751) and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c75030028.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c75030028.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c75030028.repval(e,c)
	return c75030028.repfilter(c,e:GetHandlerPlayer())
end
function c75030028.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

