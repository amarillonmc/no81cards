--公决的命数  拉克希丝
function c11771285.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(c.IsEffectProperty,aux.EffectPropertyFilter(EFFECT_FLAG_DICE)),2,true)
	-- 加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771285,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11771285)
	e1:SetCondition(c11771285.con1)
	e1:SetTarget(c11771285.tg1)
	e1:SetOperation(c11771285.op1)
	c:RegisterEffect(e1)
	-- 骰子效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771285,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11771286)
	e2:SetTarget(c11771285.tg2)
	e2:SetOperation(c11771285.op2)
	c:RegisterEffect(e2)
end
-- 1
function c11771285.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c11771285.filter1(c)
	return c:IsFaceupEx() and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE)) and c:IsAbleToHand()
end
function c11771285.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11771285.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11771285.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11771285.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 2
function c11771285.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771285.op2(e,tp,eg,ep,ev,re,r,rp)
    local ch=Duel.GetCurrentChain()
    if ch>1 then
        local p,code,te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_EFFECT)
        if p==1-tp and te and te:IsActiveType(TYPE_MONSTER) then
            Duel.NegateEffect(ev)
        end
    end
    local d=Duel.TossDice(tp,1)
    if d==1 or d==3 or d==5 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
        local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
        if #g>0 then
            Duel.GetControl(g:GetFirst(),1-tp)
        end
    elseif d==2 or d==4 or d==6 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,1-tp,LOCATION_MZONE,0,1,1,nil)
        if #g>0 then
            Duel.GetControl(g:GetFirst(),tp)
        end
    end
end
