-- 自定义事件（攻击力·守备力变化时）
EVENT_CUSTOM_ATK_DEF_CHANGE=65809091+100
-- 对局唯一的全局状态表
local status_table = {}
--资源获取工·矿工
function c65809091.initial_effect(c)
    -- 注册自定义事件
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_ADJUST)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(c65809091.op0)
    c:RegisterEffect(e0)
    -- 攻击下降
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65809091,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65809091)
	e1:SetCondition(c65809091.con1)
	e1:SetOperation(c65809091.op1)
	c:RegisterEffect(e1)
    -- 卡组检索
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(65809091,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
    e2:SetCode(EVENT_CUSTOM_ATK_DEF_CHANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c65809091.con2)
    e2:SetTarget(c65809091.tg2)
    e2:SetOperation(c65809091.op2)
    c:RegisterEffect(e2)
    -- 初始化状态记录
    if not status_table[c] then
        status_table[c] = {
            atk = c:GetAttack(),
            def = c:GetDefense()
        }
    end
end
-- 自定义事件
function c65809091.op0(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsLocation(LOCATION_MZONE) then
        status_table[c] = nil
        return
    end
    local current_atk = c:GetAttack()
    local current_def = c:GetDefense()
    if not status_table[c] then
        status_table[c] = {
            atk = current_atk,
            def = current_def
        }
        return
    end
    local atk_changed = (current_atk ~= status_table[c].atk)
    local def_changed = (current_def ~= status_table[c].def)
    if atk_changed or def_changed then
        status_table[c].atk = current_atk
        status_table[c].def = current_def
        Duel.RaiseSingleEvent(c,EVENT_CUSTOM_ATK_DEF_CHANGE,e,0,0,0,0)
        Duel.RaiseEvent(c,EVENT_CUSTOM_ATK_DEF_CHANGE,e,0,0,0,0)
    end
end
-- 1
function c65809091.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c65809091.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
        if c:GetAttack()<=0 or c:GetDefense()<=0 then
            Duel.Destroy(c,REASON_EFFECT)
        end
    end
end
-- 2
function c65809091.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_MZONE) and eg:IsContains(e:GetHandler())
end
function c65809091.filter2(c,check)
	return c:IsAbleToHand()
		and (c:IsCode(65809071) or (check and c:IsSetCard(0xca30,0xaa30)))
end
function c65809091.filter22(c)
	return c:IsFaceup() and c:IsCode(65809071)
end
function c65809091.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local hp=e:GetHandler():GetOwner()
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c65809091.filter22,hp,LOCATION_ONFIELD,0,1,nil)
		return Duel.IsExistingMatchingCard(c65809091.filter2,hp,LOCATION_DECK,0,1,nil,check)
	end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,hp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-hp,e:GetDescription())
end
function c65809091.op2(e,tp,eg,ep,ev,re,r,rp)
    local hp=e:GetHandler():GetOwner()
	local check=Duel.IsExistingMatchingCard(c65809091.filter22,hp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,hp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(hp,c65809091.filter2,hp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-hp,g)
	end
end
