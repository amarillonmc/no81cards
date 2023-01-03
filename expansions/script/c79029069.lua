--啸岚寒域中的往事重提
function c79029069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029069)
	e1:SetCost(c79029069.accost)
	e1:SetTarget(c79029069.actg)
	e1:SetOperation(c79029069.acop)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029069)
	e2:SetTarget(c79029069.sttg)
	e2:SetOperation(c79029069.stop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c79029069.named_with_KarlanTrade=true 
function c79029069.ctfil(c)  
	return c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_WATER) and (c:IsLocation(LOCATION_HAND+LOCATION_MZONE) or c.named_with_KarlanTrade)
end 
function c79029069.spfil(c,e,tp,g)
	return c:IsCode(79029063,79029064) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end  
function c79029069.elckfil(c)
	return c.named_with_KarlanTrade and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c79029069.ctgck(g,e,tp,ec)
	if Duel.IsExistingMatchingCard(c79029069.elckfil,tp,LOCATION_SZONE,0,1,ec) then 
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1 and Duel.IsExistingMatchingCard(c79029069.spfil,tp,LOCATION_EXTRA,0,1,g,e,tp,g)
	else 
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=0 and Duel.IsExistingMatchingCard(c79029069.spfil,tp,LOCATION_EXTRA,0,1,g,e,tp,g)
	end
end
function c79029069.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c79029069.ctfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:CheckSubGroup(c79029069.ctgck,2,2,e,tp,e:GetHandler()) end 
	local cg=g:SelectSubGroup(tp,c79029069.ctgck,false,2,2,e,tp,e:GetHandler()) 
	cg:KeepAlive()
	e:SetLabelObject(cg)
	Duel.SendtoGrave(cg,REASON_COST) 
end
function c79029069.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029069.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local xg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(c79029069.spfil,tp,LOCATION_EXTRA,0,xg,e,tp,xg)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029069.stckfil(c)
	return c.named_with_KarlanTrade and c:IsLevelAbove(6)
end
function c79029069.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,79029065) and eg:IsExists(c79029069.stckfil,1,nil) and e:GetHandler():IsSSetable() end
end
function c79029069.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end






