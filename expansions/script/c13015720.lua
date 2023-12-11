--深海姬跃出水面！
function c13015720.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,13015720) 
	e1:SetTarget(c13015720.actg) 
	e1:SetOperation(c13015720.acop) 
	c:RegisterEffect(e1)  
	--search 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,23015720) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT) end) 
	e2:SetTarget(c13015720.srtg) 
	e2:SetOperation(c13015720.srop) 
	c:RegisterEffect(e2) 
end
function c13015720.espfil(c,e,tp,mg)  
	return c:IsSetCard(0xe01) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(mg)   
end 
function c13015720.matgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c13015720.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end 
function c13015720.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c13015720.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToDeck() and c:IsCanBeLinkMaterial(nil) and (c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) end,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(13015720,0)) and g:CheckSubGroup(c13015720.matgck,1,99,e,tp) then  
		local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToDeck() and c:IsCanBeLinkMaterial(nil) end,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
		if g:CheckSubGroup(c13015720.matgck,1,99,e,tp) then  
			local mg=g:SelectSubGroup(tp,c13015720.matgck,false,1,99,e,tp) 
			local sc=Duel.SelectMatchingCard(tp,c13015720.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
			sc:SetMaterial(mg)   
			Duel.SendtoDeck(mg,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)   
			Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()   
		end 
	end   
end 
function c13015720.srfil(c) 
	return c:IsSetCard(0xe01) and c:IsType(TYPE_SPELL) and (c:IsAbleToHand() or c:IsSSetable())   
end 
function c13015720.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015720.srfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c13015720.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.IsExistingMatchingCard(c13015720.srfil,tp,LOCATION_GRAVE,0,1,nil) then 
		local sc=Duel.SelectMatchingCard(tp,c13015720.srfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		local b1=sc:IsAbleToHand() 
		local b2=sc:IsSSetable() 
		local op=2 
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015720,1),aux.Stringid(13015720,2))
		elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015720,1)) 
		elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(13015720,2))+1 
		end   
		if op==0 then 
			Duel.SendtoHand(sc,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sc)  
		elseif op==1 then 
			Duel.SSet(tp,sc)   
		end   
	end
end
