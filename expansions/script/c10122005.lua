--空想的沉吟
function c10122005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10122005.target)
	e1:SetOperation(c10122005.activate)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122005,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10122005.setcost)
	e2:SetTarget(c10122005.settg)
	e2:SetOperation(c10122005.setop)
	c:RegisterEffect(e2)  
end
function c10122005.rfilter(c,rc)
	return c:IsCode(10122011) and c:IsReleasable() and rc:IsSSetable(true)
end
function c10122005.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10122005.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,10122011)
	local g2=Duel.GetMatchingGroup(c10122005.rfilter,tp,LOCATION_SZONE,0,nil,c)
	if chk==0 then 
	   if e:GetLabel()==1 then
		  e:SetLabel(0)
		  return g2:GetCount()>0 or (g1:GetCount()>0 and c:IsSSetable())
	   else 
		  return c:IsSSetable()
	   end
	end
	if e:GetLabel()==1 then
	   e:SetLabel(0)
	   g1:Merge(g2)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local rg=g1:Select(tp,1,1,nil)
	   Duel.Release(rg,REASON_COST)
	end
end
function c10122005.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not c:IsAbleToHand() and not c:IsSSetable() then return end
	if c:IsAbleToHand() and (not c:IsSSetable() or not Duel.SelectYesNo(tp,aux.Stringid(10122005,5))) then 
	   Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
	   Duel.SSet(tp,c)
	   Duel.ConfirmCards(1-tp,c)
	end
end
function c10122005.desfilter(c)
	return c:IsFaceup() and c:IsCode(10122011) and c:IsDestructable()
end
function c10122005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10122005.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c10122005.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c10122005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
	   local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10122005.tgfilter1),tp,LOCATION_GRAVE,0,nil,tp)
	   if tg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10122005,2)) then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)	 
	   local tc=tg:Select(tp,1,1,nil):GetFirst()
	   local te=tc:GetActivateEffect()
	   if tc:IsAbleToHand() and (not te:IsActivatable(tp) or not Duel.SelectYesNo(tp,aux.Stringid(10122005,1))) then
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tg)
	   else
		  local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		  if fc then
			 Duel.SendtoGrave(fc,REASON_RULE)
			 Duel.BreakEffect()
		  end
		  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		  local tep=tc:GetControler()
		  local cost=te:GetCost()
		  if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		  Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	   end
	end
end
function c10122005.tgfilter1(c,tp)
	return c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp)) and c:IsSetCard(0xc333) 
end
