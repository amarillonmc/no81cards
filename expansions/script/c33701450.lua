--启明之魂 - 赤街 
local m=33701450
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x46f)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e02:SetCode(EVENT_SPSUMMON_SUCCESS)
	e02:SetCondition(cm.regcon)
	e02:SetOperation(cm.regop)
	e02:SetLabelObject(e1) 
	c:RegisterEffect(e02)
	--Effect 2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_DRAW)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.con1)
	e7:SetTarget(cm.tg1)
	e7:SetOperation(cm.op1)
	c:RegisterEffect(e7) 
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCode(EVENT_TO_HAND)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.con2)
	e12:SetTarget(cm.tg2)
	e12:SetOperation(cm.op2)
	c:RegisterEffect(e12) 
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,2))
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(cm.con3)
	e11:SetTarget(cm.tg3)
	e11:SetOperation(cm.op3)
	c:RegisterEffect(e11)
	--Effect 3 
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_TOGRAVE)
	e32:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e32:SetCode(EVENT_LEAVE_FIELD)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetCondition(cm.rlcon)
	e32:SetCost(cm.rlcost)
	e32:SetTarget(cm.rltg)
	e32:SetOperation(cm.rlop)
	c:RegisterEffect(e32)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.fdop)
	e5:SetLabelObject(e32)
	c:RegisterEffect(e5)
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,2,nil,ATTRIBUTE_FIRE)
end
--Effect 1
function cm.valcheck(e,c)
	local g=c:GetMaterialCount()
	e:SetLabel(g)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
		and e:GetLabelObject():GetLabel()~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	c:AddCounter(0x46f,vt)
end
--Effect 2
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return b1 and b2 and ep~=tp 
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	if chk==0 then return b1 and Duel.IsPlayerCanDraw(tp,1) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function cm.cf(c,tp)
	return not c:IsReason(REASON_DRAW) 
		and c:IsControler(1-tp) 
		and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return b1 and b2 and eg:IsExists(cm.cf,1,nil,tp) 
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	if chk==0 then return b1 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end

function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) 
		and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and c:IsReason(REASON_DESTROY) 
		and c:IsReason(REASON_EFFECT)
		and rp==1-tp 
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	local b2=Duel.GetLP(tp)<Duel.GetLP(1-tp)
	return b1 and b2 and eg:IsExists(cm.cfilter,1,nil,tp,rp) 
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	local lt=c:GetFlagEffect(m)
	local b1=ct>0 and lt<=ct
	if chk==0 then return b1 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Effect 3 
function cm.fdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46f)
	e:GetLabelObject():SetLabel(ct)
end
function cm.rlcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and e:GetLabel()>0
end
function cm.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.rtg(c,tp)
	return Duel.IsPlayerCanSendtoGrave(1-tp,c) 
end
function cm.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.rtg,tp,0,LOCATION_ONFIELD,nil,tp)
	if chk==0 then return ct>0 and #g>=ct end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
end
function cm.rlop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.rtg,tp,0,LOCATION_ONFIELD,nil,tp)
	if ct>0 and #g>=ct then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(1-tp,cm.rtg,ct,ct,nil,tp)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
