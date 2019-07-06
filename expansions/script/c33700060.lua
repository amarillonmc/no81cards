--动物朋友 都是朋友
function c33700060.initial_effect(c)
	c33700060[c]={}
	local effect_list=c33700060[c]
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700060.cost)
	e1:SetTarget(c33700060.target)
	e1:SetOperation(c33700060.activate)
	c:RegisterEffect(e1)
end
c33700060.card_code_list={33700056}
function c33700060.filter(c)
	return c:IsSetCard(0x442) and c:IsDiscardable() 
end
function c33700060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700060.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c33700060.filter,1,1,REASON_COST)
end
function c33700060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33700060.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700060.thfilter(c)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700060.sfilter(c)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c33700060.activate(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700060.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
	Duel.BreakEffect()
   if g:GetClassCount(Card.GetCode)>2 then
	  local tg=Duel.GetMatchingGroup(c33700060.confilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
 if g:GetClassCount(Card.GetCode)>6 and Duel.IsExistingMatchingCard(c33700060.thfilter,tp,LOCATION_DECK,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local cg=Duel.SelectMatchingCard(tp,c33700060.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if cg:GetCount()>0 then
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cg)
	end
end
if g:GetClassCount(Card.GetCode)>12 and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c33700060.sfilter,tp,LOCATION_HAND,0,1,nil) then
   local ft=Duel.GetMZoneCount(tp)
	local sg=Duel.GetMatchingGroup(c33700060.sfilter,tp,LOCATION_HAND,0,nil)
	if ft<=0 or sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local s=sg:Select(tp,ft,ft,nil)
	local t=s:GetFirst()
	while t do
		Duel.Summon(tp,t,true,nil)
		e:GetHandler():SetCardTarget(t)
		t=s:GetNext()
	end
end
   local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
 if g:GetClassCount(Card.GetCode)>19 and hg:GetClassCount(Card.GetCode)==hg:GetCount() then 
	 Duel.SetLP(tp,8000)
end
end
end