--次元飘渺 依璐凯诺
function c11560305.initial_effect(c)
	c:EnableReviveLimit()
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)   
	e1:SetTarget(c11560305.sptg)  
	e1:SetOperation(c11560305.spop) 
	c:RegisterEffect(e1)	
	--ng 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11560305,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11560305.ngcon)
	e2:SetCost(c11560305.ngcost)
	e2:SetTarget(c11560305.ngtg)
	e2:SetOperation(c11560305.ngop)
	c:RegisterEffect(e2)  
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11560305,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,21560305)
	e3:SetCondition(c11560305.rspcon)
	e3:SetTarget(c11560305.rsptg)
	e3:SetOperation(c11560305.rspop)
	c:RegisterEffect(e3)
end 
c11560305.SetCard_XdMcy=true 
function c11560305.spgck(g,tp)  
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,g:GetCount(),nil)  
end 
function c11560305.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
	if chk==0 then return g:CheckSubGroup(c11560305.spgck,1,3,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_DECK) 
end 
function c11560305.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)	
	if g:CheckSubGroup(c11560305.spgck,1,3,tp) then 
	local sg=g:SelectSubGroup(1-tp,c11560305.spgck,false,1,3,tp)  
	local x=Duel.SendtoGrave(sg,REASON_EFFECT) 
	Duel.BreakEffect() 
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,x,x,nil) 
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end 
end  
function c11560305.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetCurrentChain()
	local te,p=Duel.GetChainInfo(n-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return rp==1-tp and p==tp and te and te:GetHandler().SetCard_XdMcy and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end 
function c11560305.ngckfil(c,rtype)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost()
end
function c11560305.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560305.ngckfil,tp,LOCATION_HAND,0,1,nil,rtype) end
	local g=Duel.SelectMatchingCard(tp,c11560305.ngckfil,tp,LOCATION_HAND,0,1,1,nil,rtype) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end
function c11560305.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c11560305.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--  if Duel.IsChainDisablable(0) then
--	  local sel=1
--	  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
--	  Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(11560305,0))
--	  if g:GetCount()>0 then
--		  sel=Duel.SelectOption(1-tp,1213,1214)
--	  else
--		  sel=Duel.SelectOption(1-tp,1214)+1
--	  end
--	  if sel==0 then
--		  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
--		  local sg=g:Select(1-tp,1,1,nil)
--		  Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
--		  Duel.NegateEffect(0)
--		  return
--	  end
--  end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end  
function c11560305.rspcon(e,tp,eg,ep,ev,re,r,rp) 
	local n=Duel.GetCurrentChain()
	local te,p=Duel.GetChainInfo(n-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return rp==1-tp and p==tp and te and te:GetHandler().SetCard_XdMcy and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end 
function c11560305.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c11560305.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT) 
	end 
	end 
end 




