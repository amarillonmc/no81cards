--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]

--黑刃猎刀·狄克推多
--aux.Stringid(id,0)="装备到「火之晨曦」怪兽"
--aux.Stringid(id,1)="给与对方那只怪兽攻击力部分数值的伤害"
local s,id,o=GetID()
function s.initial_effect(c)
	-- 装备效果
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	
	-- 装备限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	
	--Increase ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	
	--Piercing damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	
	--Inflict damage after battle
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.damcon)
	e5:SetTarget(s.damtg)
	e5:SetOperation(s.damop)
	c:RegisterEffect(e5)

	--Self-equip when sent to GY
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,id+1)
	e6:SetCondition(s.eqcon)
	e6:SetTarget(s.eqtg2)
	e6:SetOperation(s.eqop2)
	c:RegisterEffect(e6)
end

function s.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_MZONE,LOCATION_MZONE)*300
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec) and ec:IsStatus(STATUS_OPPO_BATTLE)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	
	if chk==0 then return dam>0 end
	
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

-- 装备目标过滤器
function s.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) -- 0xc50是火之晨曦卡组的setcode
end

-- 装备限制函数
function s.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end

-- 装备目标函数
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

-- 装备操作函数
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsSetCard(0xc50) then
		Duel.Equip(tp,c,tc)
	end
end

-- 墓地装备条件
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

-- 墓地装备目标
function s.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsControler(tp)
end

function s.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

-- 墓地装备操作
function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Equip(tp,c,tc)
	end
end