--篡夺的米米克酱
local cm, m = GetID()
local FLAG_IS_FLIP = m + 1
local FLAG_IS_FLIP_CLIENT = m + 2
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	if cm.global then return end
	cm.global = 1
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_FLIP)
	ge1:SetOperation(cm.gop1)
	Duel.RegisterEffect(ge1,0)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	if ev < 2 then return false end
	for i = 1, ev do
		if Duel.GetChainInfo(i, CHAININFO_TRIGGERING_PLAYER) == tp then return false end
	end
	return true
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and not g:IsExists(aux.NOT(Card.IsCanTurnSet),1,nil)
		and #g > 0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) == 0 then return end
	local g = Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g == 0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,tc:GetPosition())
	end
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetReset(RESET_EVENT+EVENT_CHAIN_END)
	e1:SetOperation(cm.op1op1)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1con1f(c)
	return c:GetFlagEffect(m)>0
end
function cm.op1op1(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local g = Duel.GetMatchingGroup(cm.op1con1f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g == 0 then return end
	for tc in aux.Next(g) do
		Duel.ChangePosition(tc,tc:GetFlagEffectLabel(m))
		tc:ResetFlagEffect(m)
	end
end
--e2
function cm.tg2f(c)
	return c:GetFlagEffect(FLAG_IS_FLIP)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	tp = Duel.GetTurnPlayer()
	local g = Duel.GetMatchingGroup(cm.tg2f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,g) end
end
function cm.GetLinkMaxCount(c, mg)
	mg = mg:Filter(Card.IsCanBeLinkMaterial,nil,c)
	local max = #mg > 12 and 12 or #mg
	for i = max, 1, -1 do
		if c:IsLinkSummonable(mg,nil,i,i) then return i end
	end
	return 0
end
function cm.GetLinkGroup(lg,mg)
	local rg, maxct = Group.CreateGroup(), 0
	for lc in aux.Next(lg) do
		local ct = cm.GetLinkMaxCount(lc, mg)
		if ct > maxct then
			maxct = ct
			rg = Group.FromCards(lc)
		elseif ct == maxct then
			rg = rg + lc
		end
	end
	return rg, maxct
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	tp = Duel.GetTurnPlayer()
	local mg = Duel.GetMatchingGroup(cm.tg2f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #mg == 0 then return end
	for tc in aux.Next(mg) do
		tc:RegisterFlagEffect(FLAG_IS_FLIP_CLIENT,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	local lg = Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,mg)
	lg, max = cm.GetLinkGroup(lg,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	lg = lg:Select(tp,1,1,nil)
	Duel.LinkSummon(tp,lg:GetFirst(),mg,nil,max,max)
	for tc in aux.Next(mg:Filter(Card.IsLocation(LOCATION_MZONE))) do
		tc:ResetFlagEffect(FLAG_IS_FLIP_CLIENT)
	end
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return r == REASON_LINK 
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e1, true)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m, 1))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	rc:RegisterEffect(e2, true)
end
--ge1
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(FLAG_IS_FLIP,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end