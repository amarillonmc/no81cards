--被破坏轮惩罚的灰流丽
function c35531515.initial_effect(c)
	aux.AddCodeList(c,14558127)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c35531515.cost)
	c:RegisterEffect(e1) 
	--to grave 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35531515,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1)
	e1:SetLabel(1)
	e1:SetCondition(c35531515.effcon)
	e1:SetTarget(c35531515.tgtg)
	e1:SetOperation(c35531515.tgop)
	c:RegisterEffect(e1) 
	--SpecialSummon  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35531515,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1)
	e2:SetLabel(3)
	e2:SetCondition(c35531515.effcon)
	e2:SetTarget(c35531515.sptg)
	e2:SetOperation(c35531515.spop)
	c:RegisterEffect(e2)
	--SpecialSummon  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35531515,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1)
	e2:SetLabel(5)
	e2:SetCondition(c35531515.effcon)
	e2:SetTarget(c35531515.esptg)
	e2:SetOperation(c35531515.espop)
	c:RegisterEffect(e2)
end 
function c35531515.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127))
end  
function c35531515.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35531515.ctfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c35531515.ctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c35531515.effcon(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(function(c) return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) end,tp,LOCATION_GRAVE,0,nil)>=e:GetLabel() 
end 
function c35531515.tgfil(c)
	return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c35531515.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35531515.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c35531515.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c35531515.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c35531515.spfil(c,e,tp)
	return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35531515.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c35531515.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c35531515.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35531515.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c35531515.tdfil(c) 
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsLevelAbove(1)  
end 
function c35531515.espfil(c,e,tp,g) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsLevel(g:GetSum(Card.GetLevel)) and aux.IsCodeListed(c,14558127) and c:IsType(TYPE_SYNCHRO) 
end 
function c35531515.tdgck(g,e,tp) 
	return g:FilterCount(function(c) return c:IsType(TYPE_TUNER) end,nil)==1 
	   and g:FilterCount(function(c) return not c:IsType(TYPE_TUNER) end,nil)==1 
	   and Duel.IsExistingMatchingCard(c35531515.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end  
function c35531515.esptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c35531515.tdfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c35531515.tdgck,2,2,e,tp) end
	local sg=g:SelectSubGroup(tp,c35531515.tdgck,false,2,2,e,tp) 
	sg:KeepAlive() 
	e:SetLabelObject(sg) 
	Duel.SendtoDeck(sg,nil,2,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35531515.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=e:GetLabelObject()  
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c35531515.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) then 
		local sc=Duel.SelectMatchingCard(tp,c35531515.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure() 
	end  
end


