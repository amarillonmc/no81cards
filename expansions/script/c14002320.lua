--【BOSS】异海城之主
local m=14002320
local cm=_G["c"..m]
cm.named_with_Hastur=1
function cm.initial_effect(c)
	--SpecialSummon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--Special Summon procedure (from Hand/GY)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(cm.aclimit)
	c:RegisterEffect(e5)
	--SearchCard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(cm.thcon)
	e6:SetCost(cm.thcost)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_HAND)
	e7:SetCost(cm.thcost)
	e7:SetTarget(cm.thtg)
	e7:SetOperation(cm.thop)
	c:RegisterEffect(e7)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.get_available_field(tp,code)
	if not UraraG_fieldcheck then return nil end
	local c=nil
	if code==14002341 and UraraG_fieldcheck.release then
		c=UraraG_fieldcheck.release[tp]
	elseif code==14002342 and UraraG_fieldcheck.counter then
		c=UraraG_fieldcheck.counter[tp]
	end
	if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
		return c
	end
	return nil
end
function cm.req_lv(tp)
	local gy_ct = Duel.GetFieldGroupCount(tp, LOCATION_GRAVE, 0)
	return math.max(1, 7 - math.floor(gy_ct / 3))
end
function cm.relfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function cm.deck_cost_filter(c)
	return cm.Urara(c) and c:IsAbleToGraveAsCost()
end
function cm.spcheck(g, req, tp)
	if g:GetSum(Card.GetLevel) < req then return false end
	for tc in aux.Next(g) do
		local g2 = g:Clone()
		g2:RemoveCard(tc)
		if g2:GetSum(Card.GetLevel) >= req and Duel.GetMZoneCount(tp, g2) > 0 then
			return false
		end
	end
	return Duel.GetMZoneCount(tp,g)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local req=cm.req_lv(tp)
	local g=Duel.GetMatchingGroup(cm.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local b1=g:CheckSubGroup(cm.spcheck,1,99,req,tp)
	local b2=cm.get_available_field(tp, 14002341) ~= nil
		and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	return b1 or b2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local req=cm.req_lv(tp)
	local g=Duel.GetMatchingGroup(cm.relfilter, tp, LOCATION_MZONE,LOCATION_MZONE,nil)
	local b1=g:CheckSubGroup(cm.spcheck,1,99,req,tp)
	local fc=cm.get_available_field(tp, 14002341)
	local b2=(fc~=nil) 
		and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp, LOCATION_MZONE)>0
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp, aux.Stringid(m,1), aux.Stringid(14002341,1))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		local cancel = Duel.IsSummonCancelable()
		local sg = g:SelectSubGroup(tp, cm.spcheck, cancel, 1, 99, req, tp)
		if not sg then return false end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(0)
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local sg = Duel.SelectMatchingCard(tp, cm.deck_cost_filter, tp, LOCATION_DECK, 0, 1, 1, nil)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(1)
		fc:RegisterFlagEffect(14002341, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
	end
	return true
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	if e:GetLabel()==0 then
		Duel.Release(sg, REASON_COST)
	else
		Duel.SendtoGrave(sg, REASON_COST)
	end
	sg:DeleteGroup()
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,target_p)
	return c:IsLevelBelow(3)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLevelBelow(3)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLevelBelow(3)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c, REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return cm.Hastur(c) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m)
end