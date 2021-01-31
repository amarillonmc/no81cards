--方舟之骑士·迷迭香
function c29065502.initial_effect(c)
  c:SetSPSummonOnce(29065502)
 c:EnableCounterPermit(0x87ae)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c29065502.splimit)
	c:RegisterEffect(e0)
 --sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065502,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065501)
	e1:SetCost(c29065502.spcost)
	e1:SetTarget(c29065502.sptg)
	e1:SetOperation(c29065502.spop)
	c:RegisterEffect(e1)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065502,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,29065501)
	e2:SetCost(c29065502.setcost)
	e2:SetTarget(c29065502.settg)
	e2:SetOperation(c29065502.setop)
	c:RegisterEffect(e2)
 --Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065502,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c29065502.descost)
	e3:SetTarget(c29065502.destg)
	e3:SetOperation(c29065502.desop)
	c:RegisterEffect(e3)
end
function c29065502.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsCode(29065502,29065501)
end

function c29065502.cfilter(c)
	return  c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_ONFIELD,0,1,c)
end
function c29065502.check(g)
	return  g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c29065502.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic()  end  
end
function c29065502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsExistingMatchingCard(c29065502.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsCanRemoveCounter(tp,1,0,0x87ae,6,REASON_EFFECT)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29065502.spop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(c29065502.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsCanRemoveCounter(tp,1,0,0x87ae,6,REASON_EFFECT) then return end
	local pd1=Duel.IsExistingMatchingCard(c29065502.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local pd2=Duel.IsCanRemoveCounter(tp,1,0,0x87ae,6,REASON_EFFECT)
	if pd1 and  pd2 then	
	op=Duel.SelectOption(tp,aux.Stringid(29065501,3),aux.Stringid(29065501,4))
	else if pd1 then op=0 
	else op=1 
	end 
	if op==0 then 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:SelectSubGroup(tp,c29065502.check,false,2,2)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	else	
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x87ae,6,REASON_EFFECT)
	end
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c29065502.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic()  end			  
end
function c29065502.tffilter(c,tp)
	return c:IsCode(29065501) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c29065502.tdfilter(c)
	return  c:IsAbleToDeck() and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29065502.settg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c29065502.tffilter,tp,LOCATION_DECK,0,1,nil,tp)
   and Duel.IsExistingMatchingCard(c29065502.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)   end
end
function c29065502.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not  Duel.IsExistingMatchingCard(c29065502.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c29065502.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)   
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c29065502.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
end

function c29065502.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsCanRemoveCounter(tp,1,0,0x87ae,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x87ae,1,REASON_COST)
end
function c29065502.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c29065502.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)	
	end
end




