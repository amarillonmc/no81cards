--堕福的殉钟 无声恸哭
local s,id,o=GetID()
function s.initial_effect(c)

    -- 天使族6星怪兽×2只以上
    c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),6,2,nil,nil,99)
	
	-- 这张卡的攻击力·守备力上升这张卡作为超量素材中的「堕福」怪兽的各自数值
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(s.defval)
	c:RegisterEffect(e2)
	
	-- ●光：对方场上的表侧表示怪兽变成攻击表示，可以攻击的对方怪兽必须向这张卡作出攻击
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.xyzcon1)
	e3:SetTarget(s.postg)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.xyzcon1)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(s.atklimit)
	c:RegisterEffect(e5)
	
	-- ●暗：每次对方把魔法·陷阱卡的效果发动，给与对方600伤害
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.damcon)
	e7:SetOperation(s.damop)
	c:RegisterEffect(e7)
end

-- 这张卡的攻击力·守备力上升这张卡作为超量素材中的「堕福」怪兽的各自数值
function s.atkfilter(c)
	return c:IsSetCard(0x666c) and c:GetAttack()>=0
end

function s.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end

function s.deffilter(c)
	return c:IsSetCard(0x666c) and c:GetDefense()>=0
end

function s.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

-- 这张卡得到这张卡作为超量素材中的怪兽属性的以下效果
function s.xyzcon1(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end

function s.xyzcon2(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end

-- ●光：对方场上的表侧表示怪兽变成攻击表示，可以攻击的对方怪兽必须向这张卡作出攻击
function s.postg(e,c)
	return c:IsFaceup()
end

function s.atklimit(e,c)
	return c==e:GetHandler()
end

-- ●暗：每次对方把魔法·陷阱卡的效果发动，给与对方600伤害
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return s.xyzcon2(e) and ep~=tp and Duel.GetLP(1-tp)>0 
		and c:GetFlagEffect(id)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,600,REASON_EFFECT)
end
