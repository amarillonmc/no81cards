--深海姬·圆水母
function c13015716.initial_effect(c)
	c:SetSPSummonOnce(13015716)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xe01),1,1) 
	--search 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c13015716.srtg) 
	e1:SetOperation(c13015716.srop) 
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,13015716+EFFECT_COUNT_CODE_DUEL)  
	e2:SetCost(c13015716.spcost)
	e2:SetTarget(c13015716.sptg)
	e2:SetOperation(c13015716.spop)
	c:RegisterEffect(e2)
end 
function c13015716.srfil(c) 
	return c:IsSetCard(0xe01) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())   
end 
function c13015716.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c13015716.srfil,tp,LOCATION_DECK,0,1,nil) end  
	local g=Duel.SelectTarget(tp,function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_ONFIELD,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c13015716.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c13015716.srfil,tp,LOCATION_DECK,0,1,nil) then 
		local sc=Duel.SelectMatchingCard(tp,c13015716.srfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		local b1=sc:IsAbleToHand() 
		local b2=sc:IsSSetable() 
		local op=2 
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015716,1),aux.Stringid(13015716,2))
		elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015716,1)) 
		elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015716,2))+1 
		end   
		if op==0 then 
			Duel.SendtoHand(sc,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sc)  
		elseif op==1 then 
			Duel.SSet(tp,sc)   
		end   
	end
end 
function c13015716.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xe01)  
end 
function c13015716.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c13015716.ctfil,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(aux.dncheck,4,4) end 
	local rg=g:SelectSubGroup(tp,aux.dncheck,false,4,4) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST) 
end 
function c13015716.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13015716.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
