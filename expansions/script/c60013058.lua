-- 片鳞·暗
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")

local F_CALL=m+10000000	-- 对方把效果发动的次数
local F_USE=m+20000000	-- 这个②已经发动的次数
local F_REC=m+30000000	-- ①的回复累积：每发动1次，这次决斗中「片鳞·暗」①与「循环之刃」②的回复+400

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」
	aux.AddCodeList(c,60013050)

	-- ①：作为通常魔法发动。回复400基本分，那之后可以拿「剑穗」
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：手卡的这张卡持续公开 + 场上有罗丝薇瑟，对方把效果发动每有10次可以发动（手卡诱发）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)

	-- 计数：对方把效果发动的次数
	if not cm.global_check then
		cm.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAINING)
		ge:SetOperation(cm.cntop)
		Duel.RegisterEffect(ge,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(cm.cntop)
		Duel.RegisterEffect(ge2,1)
	end
end

function cm.cntop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp then return end
	Duel.RegisterFlagEffect(tp,F_CALL,0,0,1)
end

-- ①
function cm.suifilter(c)
	return c:IsCode(60013053) and c:IsAbleToHand()
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	-- 基础400，本次决斗中每适用过1次再+400（本次适用时先结算旧的累积）
	local rec=400+400*Duel.GetFlagEffect(tp,F_REC)
	Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,F_REC,0,0,1)
	if not Duel.IsExistingMatchingCard(cm.suifilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.suifilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()==0 then return end
	local fd=g:GetFirst():IsLocation(LOCATION_DECK)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	cm.recop(e,tp,eg,ep,ev,re,r,rp)
end

-- ②
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPublic() then return false end
	if rp~=1-tp then return false end
	if re and re:GetHandler()==c then return false end
	if not Duel.IsExistingMatchingCard(Lingguang.rosefilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return math.floor(Duel.GetFlagEffect(tp,F_CALL)/10)>Duel.GetFlagEffect(tp,F_USE)
end
function cm.mingfil(c)
	return c:IsCode(60013057) and c:IsAbleToGrave()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,F_USE,0,0,1)
	-- 这张卡发动时的效果适用
	cm.recop(e,tp,eg,ep,ev,re,r,rp)
	-- 那之后，可以把这张卡和手卡1张「片鳞·明」送去墓地
	if not c:IsLocation(LOCATION_HAND) then return end
	if not Duel.IsExistingMatchingCard(cm.mingfil,tp,LOCATION_HAND,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mingfil,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	if not c:IsLocation(LOCATION_GRAVE) then return end
	-- 确认对方手卡，从那之中选1张除外
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(tp,hg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_HAND,1,1,nil)
	if rg:GetCount()>0 then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
end
