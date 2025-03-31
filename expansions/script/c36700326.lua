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

--御神刀·村雨
--aux.Stringid(id,0)="将怪兽变成里侧守备表示"
--aux.Stringid(id,1)="使自己的战士族和炎属性怪兽可以作2次攻击"
local s,id,o=GetID()
function s.initial_effect(c)
	-- 装备效果
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(s.eqtg)
	e0:SetOperation(s.eqop)
	c:RegisterEffect(e0)
	--equip limit
	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_SINGLE)
	ee:SetCode(EFFECT_EQUIP_LIMIT)
	ee:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ee:SetValue(s.eqlimit)
	c:RegisterEffect(ee)

	--Increase ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--Cannot be targeted by opponent's effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
	--Change to face-down defense position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.postg)
	e4:SetOperation(s.posop)
	c:RegisterEffect(e4)
	
	--Additional attacks
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.atkcon)
	e5:SetCost(s.atkcost)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		
		--Negate targeted monster's effects during battle
		local ec=c:GetEquipTarget()
		if ec and ec:IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetTarget(s.distg)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.distg(e,c)
	return c==Duel.GetAttackTarget() or c==Duel.GetAttacker()
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec==Duel.GetAttacker() and ec:IsRelateToBattle()
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	
	--Warrior monsters can attack twice
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	--FIRE monsters can attack twice
	local e2=e1:Clone()
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	Duel.RegisterEffect(e2,tp)
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
-- 装备目标过滤器
function s.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) -- 0xc50是火之晨曦卡组的setcode
end

-- 装备限制函数
function s.eqlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end
