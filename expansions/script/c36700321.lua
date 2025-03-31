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

--沙漠之鹰
--aux.Stringid(id,0)="装备到「火之晨曦」怪兽"
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate

	--equip limit
	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_SINGLE)
	ee:SetCode(EFFECT_EQUIP_LIMIT)
	ee:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ee:SetValue(s.eqlimit)
	c:RegisterEffect(ee)

	-- 装备效果
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(s.eqstg)
	e0:SetOperation(s.eqsop)
	c:RegisterEffect(e0)
	
	--攻击两次+改变数值
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(s.defval)
	c:RegisterEffect(e3)
	
	--装备
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.eqcon)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0xc50) and c:IsFaceup()
end

function s.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==ec
end

function s.atkval(e,c)
	return c:GetAttack()+500
end

function s.defval(e,c)
	return c:GetDefense()+500
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Equip(tp,c,tc)
	end
end
-- 装备目标函数
function s.eqstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqsfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

-- 装备操作函数
function s.eqsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsSetCard(0xc50) then
		Duel.Equip(tp,c,tc)
	end
end
-- 装备目标过滤器
function s.eqsfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) -- 0xc50是火之晨曦卡组的setcode
end

-- 装备限制函数
function s.eqslimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end
