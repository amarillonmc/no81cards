--资源获取工·发电工
-- 自定义事件（攻击力·守备力变化时）
EVENT_CUSTOM_ATK_DEF_CHANGE1=65809141+100
-- 对局唯一的全局状态表
local status_table1 = {}
local s,id,o=GetID()
function s.initial_effect(c)
	-- 注册自定义事件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(s.op0)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1113)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--卡组检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM_ATK_DEF_CHANGE1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	if not status_table1[c] then
		status_table1[c] = {
			atk = c:GetAttack(),
			def = c:GetDefense()
		}
	end
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then
		status_table1[c] = nil
		return
	end
	local current_atk = c:GetAttack()
	local current_def = c:GetDefense()
	if not status_table1[c] then
		status_table1[c] = {
			atk = current_atk,
			def = current_def
		}
		return
	end
	local atk_changed = (current_atk ~= status_table1[c].atk)
	local def_changed = (current_def ~= status_table1[c].def)
	if atk_changed or def_changed then
		status_table1[c].atk = current_atk
		status_table1[c].def = current_def
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM_ATK_DEF_CHANGE1,e,0,0,0,0)
		Duel.RaiseEvent(c,EVENT_CUSTOM_ATK_DEF_CHANGE1,e,0,0,0,0)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsAttackAbove(500) and c:IsDefenseAbove(500) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
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
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and eg:IsContains(e:GetHandler())
end
function s.filter2(c,check)
	return c:IsAbleToHand()
		and (c:IsCode(65809151) or (check and c:IsSetCard(0xca30,0xaa30)))
end
function s.filter22(c)
	return c:IsFaceup() and c:IsCode(65809151)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(s.filter22,tp,LOCATION_ONFIELD,0,1,nil)
		return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,hp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(s.filter22,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end