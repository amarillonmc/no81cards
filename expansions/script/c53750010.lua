local m=53750010
local cm=_G["c"..m]
cm.name="异律匿岁"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target4)
	e1:SetOperation(cm.activate4)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetTarget(cm.target3)
	e3:SetOperation(cm.activate3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTarget(cm.target1)
	e4:SetOperation(cm.activate1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,exc) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,exc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,exc)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function cm.rmfilter(c)
	return c:GetFlagEffect(m)==0 and c:IsFaceup() and c:IsAbleToRemove()
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x9532) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.filter(c,tp,re)
	return c:IsPreviousControler(tp) and c:IsRace(RACE_REPTILE) and c:IsReason(REASON_COST) and re and c==re:GetHandler() and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp,re) and e:GetHandler():IsAbleToRemove() and not eg:IsContains(e:GetHandler()) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter,nil,tp,re):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then Duel.SendtoHand(sg,nil,REASON_EFFECT) end
end
