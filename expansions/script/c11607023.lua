--璀璨原钻开采场
function c11607023.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- 效果伤害
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c11607023.reccon)
	e1:SetOperation(c11607023.recop)
	c:RegisterEffect(e1)
	-- 嘲讽攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c11607023.atkcon)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2a:SetValue(c11607023.atklimit)
	c:RegisterEffect(e2a)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetRange(LOCATION_FZONE)
	e2b:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2b:SetCondition(c11607023.atkcon)
	e2b:SetTargetRange(0,1)
	c:RegisterEffect(e2b)
	-- 送去墓地
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11607023,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11607023)
	e3:SetCondition(c11607023.tgcon)
	e3:SetTarget(c11607023.tgtg)
	e3:SetOperation(c11607023.tgop)
	c:RegisterEffect(e3)
end
-- 1
function c11607023.cfilter(c)
	return c:IsSetCard(0x6225) and c:IsType(TYPE_MONSTER)
end
function c11607023.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11607023.cfilter,1,nil)
end
function c11607023.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c11607023.cfilter,nil)
	if #g>0 then
		local total_level=0
		local monster_count=#g
		for tc in aux.Next(g) do
			total_level=total_level+tc:GetLevel()
		end
		local recover_val=total_level*200
		Duel.Recover(tp,recover_val,REASON_EFFECT)
		local damage_val=monster_count*200
		Duel.Damage(1-tp,damage_val,REASON_EFFECT)
	end
end
-- 2
function c11607023.atkcon(e)
	return Duel.IsExistingMatchingCard(c11607023.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11607023.atklimit(e,c)
	return c:IsFaceup() and c:IsControler(e:GetHandlerPlayer()) and c11607023.cfilter(c)
end
-- 3
function c11607023.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11607023.cfilter,1,nil)
end
function c11607023.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
end
function c11607023.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
