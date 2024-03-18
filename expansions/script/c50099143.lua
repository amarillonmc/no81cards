--仗剑走天涯 渔樵耕读
function c50099143.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,50099143+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c50099143.accost)
	e1:SetTarget(c50099143.actg)
	e1:SetOperation(c50099143.acop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10099143) 
	e2:SetTarget(c50099143.thtg)
	e2:SetOperation(c50099143.thop)
	c:RegisterEffect(e2)
end
function c50099143.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099143.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c50099143.espfil(c,e,tp,g) 
	return c:IsSetCard(0x998) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c50099143.ctgck(g,e,tp) 
	return g:IsExists(Card.IsSetCard,1,nil,0x998) and Duel.GetLocationCountFromEx(tp,tp,g,TYPE_SYNCHRO)>0  
end 
function c50099143.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c50099143.ctgck,2,2,e,tp) end 
	local rg=g:SelectSubGroup(tp,c50099143.ctgck,false,2,2,e,tp) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST) 
end  
function c50099143.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50099143.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50099143.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sc=Duel.SelectMatchingCard(tp,c50099143.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if sc then 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
	end  
end 











