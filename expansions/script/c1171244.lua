--斥血鬼 吸血鬼阿鲁卡多
function c1171244.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),10,2,nil,nil,99)
    --lv change
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c1171244.tg0)
	e0:SetValue(c1171244.val0)
	c:RegisterEffect(e0)
    -- 抗性效果
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c1171244.filter1)
	c:RegisterEffect(e2)]]
    -- 战吼检索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1171244,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,1171244)
	e3:SetTarget(c1171244.tg2)
	e3:SetOperation(c1171244.op2)
	c:RegisterEffect(e3)
	-- 效果无效
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1171244,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1171245)
	e4:SetCondition(c1171244.con3)
	e4:SetCost(c1171244.cost3)
	e4:SetTarget(c1171244.tg3)
	e4:SetOperation(c1171244.op3)
	c:RegisterEffect(e4)
end
-- 超量素材等级
function c1171244.tg0(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c1171244.val0(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 10
	else return lv end
end
-- 1
--[[function c1171244.filter1(e,c,te)
	return te:GetOwner()~=e:GetOwner() and c:IsType(TYPE_MONSTER) and not (te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and te:GetHandler():IsLocation(LOCATION_GRAVE))
end]]
-- 2
function c1171244.filter2(c)
	return c:IsSetCard(0x8e) and c:IsAbleToHand()
end
function c1171244.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1171244.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1171244.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c1171244.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,g)
        local og=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_MZONE,LOCATION_MZONE,nil,RACE_ZOMBIE)
        if #og>0 then
            if Duel.SelectYesNo(tp,aux.Stringid(1171244,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
                local sg=og:Select(tp,1,1,nil)
                Duel.Overlay(e:GetHandler(),sg)
            end
        end
    end
end
-- 3
function c1171244.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c1171244.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c1171244.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c1171244.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		if re:GetHandler():IsRace(RACE_ZOMBIE) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
