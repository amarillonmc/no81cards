local m=53750004
local cm=_G["c"..m]
cm.name="异律候胧"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target4)
	e1:SetOperation(cm.activate4)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetTarget(cm.target3)
	e3:SetOperation(cm.activate3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTarget(cm.target1)
	e4:SetOperation(cm.activate1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.check)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_MOVE)
	e6:SetCondition(cm.checkcon)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetOperation(cm.regop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,4))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_CUSTOM+m)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.thcon)
	e8:SetTarget(cm.thtg)
	e8:SetOperation(cm.thop)
	c:RegisterEffect(e8)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.tgfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToGrave()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function cm.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate4(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,ft)
	if sg and sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_REMOVED) and c:IsReason(REASON_RETURN)
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()<3 or e:GetHandler():GetFlagEffect(m)>0 then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
