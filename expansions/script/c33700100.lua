--动物游行
function c33700100.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetTarget(c33700100.target)
	e1:SetOperation(c33700100.damop)
	c:RegisterEffect(e1)
	--no damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(aux.damcon1)
	e2:SetTarget(c33700100.target2)
	e2:SetOperation(c33700100.operation)
	c:RegisterEffect(e2)
end
function c33700100.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700100.confilte2(c)
	return c:IsSetCard(0x442) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c33700100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	   local g=Duel.GetMatchingGroup(c33700100.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	if chk==0 then return ((g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 and Duel.IsExistingMatchingCard(c33700100.confilter2,tp,LOCATION_DECK,0,1,nil)) or (g:GetClassCount(Card.GetCode)>=9 and Duel.IsPlayerCanDraw(tp,1)) or (g:GetClassCount(Card.GetCode)>=14 and Duel.IsPlayerCanDraw(tp,3)) )
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) end
   if g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 then
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,nil)
   elseif g:GetClassCount(Card.GetCode)>=9 then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
elseif g:GetClassCount(Card.GetCode)>=14 then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
end
function c33700100.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
	 Duel.BreakEffect()
	  local g=Duel.GetMatchingGroup(c33700100.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	  
	  if g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 then
	  local tg=Duel.SelectMatchingCard(tp,c33700100.confilte2,tp,LOCATION_DECK,0,1,6-g:GetClassCount(Card.GetCode),nil)
	  if tg:GetCount()>0 then 
	  Duel.SendtoGrave(tg,REASON_EFFECT)
end
end
	 if g:GetClassCount(Card.GetCode)>=9 then
	  Duel.Recover(tp,1000,REASON_EFFECT)
	   Duel.Draw(tp,1,REASON_EFFECT)
end
 if g:GetClassCount(Card.GetCode)>=14 then
   Duel.Recover(tp,2000,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
end
end
function c33700100.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	   local g=Duel.GetMatchingGroup(c33700100.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	if chk==0 then return ((g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 and Duel.IsExistingMatchingCard(c33700100.confilter2,tp,LOCATION_DECK,0,1,nil)) or (g:GetClassCount(Card.GetCode)>=9 and Duel.IsPlayerCanDraw(tp,1)) or (g:GetClassCount(Card.GetCode)>=14 and Duel.IsPlayerCanDraw(tp,3))) end
   if g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 then
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,nil)
   elseif g:GetClassCount(Card.GetCode)>=9 then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
elseif g:GetClassCount(Card.GetCode)>=14 then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
end
function c33700100.operation(e,tp,eg,ep,ev,re,r,rp)
	 local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c33700100.damcon2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	 Duel.BreakEffect()
	  local g=Duel.GetMatchingGroup(c33700100.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	  
	  if g:GetClassCount(Card.GetCode)>0 and g:GetClassCount(Card.GetCode)<6 then
	  local tg=Duel.SelectMatchingCard(tp,c33700100.confilte2,tp,LOCATION_DECK,0,1,6-g:GetClassCount(Card.GetCode),nil)
	  if tg:GetCount()>0 then 
	  Duel.SendtoGrave(tg,REASON_EFFECT)
end
end
	 if g:GetClassCount(Card.GetCode)>=9 then
	  Duel.Recover(tp,1000,REASON_EFFECT)
	   Duel.Draw(tp,1,REASON_EFFECT)
end
 if g:GetClassCount(Card.GetCode)>=14 then
   Duel.Recover(tp,2000,REASON_EFFECT)
	Duel.Draw(tp,2,REASON_EFFECT)
end
end
function c33700100.damcon2(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0 end
	return val
end