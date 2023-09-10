--向全体机凯种致以最崇高的敬意
local m=60000101
local cm=_G["c"..m]
cm.name="向全体机凯种致以最崇高的敬意"
jkz = {}
jkz.count = {}
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetConditiom(jkz.xcon)
	e2:SetTarget(cm.xxtg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local ge1 = jkz.GetCountEffect(c)
end
cm.named_with_ExMachina=true 
function cm.cfilter(c)
	return c:IsSetCard(0x6a0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function cm.xxfilter(c)
	return c:IsSetCard(0x6a0)
end
function cm.mkfilter(c)
	return c.named_with_ExMachina and c:IsType(TYPE_LINK) and c:IsAttackAbove(2500)
end
function cm.ttkfilter(c)
	return c:IsCode(60000112)
end
function cm.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	if not Duel.IsExistingMatchingCard(cm.xxfilter,tp,LOCATION_DECK,0,1,nil) then 
	e:SetLabel(1)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
	dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	end
end
------------------------------------------------------------------
function jkz.GetCountEffect(c)
    if jkz.CheckCount then return false end
    jkz.CheckCount = true
    local ge1 = Effect.GlobalEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_CHAINING)
    ge1:SetCondition(jkz.con)
    ge1:SetOperation(jkz.op)
    Duel.RegisterEffect(ge1,tp)
    return ge1
end
function jkz.con(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler().named_with_ExMachina and re:GetHandler():IsType(TYPE_MONSTER) and rp==tp
end
function jkz.op(e,tp,eg,ep,ev,re,r,rp)
    local turn = Duel.GetTurnCount()
    if not jkz.count[turn] then jkz.count[turn] = 0 end
    jkz.count[turn] = jkz.count[turn] + 1
end
function jkz.GetActCount(ct,c)
    local a , b = jkz.count(ct-1) or 0 and jkz.count(ct) or 0
    ct = a + b
    if c and type(c) == "number" then
        if ct>=c then return true
        else return false end
    end
    return ct
end
function jkz.acon(e,tp,eg,ep,ev,re,r,rp)
    local ct = Duel.GetTurnCount()
    return Duel.GetTurnPlayer() == tp or jkz.GetCount(ct,3)
end
function jkz.xcon(e,tp,eg,ep,ev,re,r,rp)
    local ct = Duel.GetTurnCount()
    return jkz.GetActCount(ct,3)
end