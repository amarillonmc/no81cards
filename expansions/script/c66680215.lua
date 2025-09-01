--堕福的殉钟 无声恸哭
local s,id,o=GetID()
function s.initial_effect(c)

    -- 幻想魔族6星怪兽×2只以上
    c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),6,2,nil,nil,99)
	
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
	
	-- ●暗：场上的这张卡不会被战斗·效果破坏
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetCondition(s.xyzcon2)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
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
