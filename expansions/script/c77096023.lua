--卡米拉·泳装
local m=77096023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--code
	aux.EnableChangeCode(c,77096021,LOCATION_MZONE+LOCATION_GRAVE)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Effect 2   
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+m)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	--Effect 3 
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_COIN+CATEGORY_DISABLE)
	e02:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1)
	e02:SetTarget(cm.distg)
	e02:SetOperation(cm.disop)
	c:RegisterEffect(e02)  
end
cm.toss_coin=true
--spsummon condition
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(77096020)
end
--Effect 1
function cm.thfilter(c)
	return c:IsCode(77096024) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end 
--Effect 2
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.rf(c)
	return c:IsFaceup() and c:IsDefenseAbove(300)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rf,tp,0,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rf,tp,0,LOCATION_MZONE,nil,e,tp)
	local rep,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if val==0 then return end
	if Duel.Recover(rep,val,REASON_EFFECT)==0 then return false end
	g=Duel.GetMatchingGroup(cm.rf,tp,0,LOCATION_MZONE,nil,e,tp)
	if #g==0 then return false end 
	for tc in aux.Next(g) do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
--Effect 3 
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetTargetsRelateToChain()
	local tc=dg:GetFirst()
	local coin=Duel.TossCoin(tp,1)
	if #dg==0 then return end
	if coin==1 then
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			tc=dg:GetNext()
		end
	end
end
