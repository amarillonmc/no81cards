--深海姬拖入谷底？
function c13015721.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,13015721) 
	e1:SetTarget(c13015721.actg) 
	e1:SetOperation(c13015721.acop) 
	c:RegisterEffect(e1) 
	--search 
  
end
function c13015721.espfil(c,e,tp,mg)  
	return c:IsType(TYPE_SYNCHRO) and mg:FilterCount(Card.IsType,nil,TYPE_TUNER)==1 and mg:FilterCount(function(c) return not c:IsType(TYPE_TUNER) end,nil)>=1 and c:GetLevel()==mg:GetSum(Card.GetLevel) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0   
end 
function c13015721.matgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c13015721.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end 
function c13015721.actg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c13015721.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsSetCard(0xe01) and c:IsAbleToRemove() and c:IsCanBeSynchroMaterial() end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and g:CheckSubGroup(c13015721.matgck,1,99,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(13015721,0)) then 
		local mg=g:SelectSubGroup(tp,c13015721.matgck,false,1,99,e,tp) 
		local sc=Duel.SelectMatchingCard(tp,c13015721.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
		sc:SetMaterial(mg)   
		Duel.Remove(mg,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)   
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()  
	end   
end 
function c13015721.srfil(c) 
	return c:IsSetCard(0xe01) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable()) 
end 
function c13015721.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015721.srfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
end 
function c13015721.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.IsExistingMatchingCard(c13015721.srfil,tp,LOCATION_GRAVE,0,1,nil) then 
		local sc=Duel.SelectMatchingCard(tp,c13015721.srfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
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