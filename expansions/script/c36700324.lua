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

--孪生猎刀·奥古斯都
--aux.Stringid(id,0)="从卡组·墓地选择1张「火之晨曦」装备魔法卡装备"
--aux.Stringid(id,1)="将这张卡从墓地装备"
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700306,id) -- 恺撒 火之晨曦
	
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
	
	--Cannot be destroyed by effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	--Equip another equip card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.eqtarget)
	e5:SetOperation(s.eqoperation)
	c:RegisterEffect(e5)
	
	--Equip from grave
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
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
	return Duel.GetMatchingGroupCount(Card.IsMonster,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*200
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

function s.eqfilter2(c,tp)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:GetCode()~=id
end

function s.eqtgfilter(c,tp,ec)
	return c:IsFaceup() and c:IsControler(tp) and ec:CheckEquipTarget(c)
end

function s.eqtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.eqtgfilter,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.kaiserfilter(c)
	return c:IsFaceup() and c:IsCode(36700304)
end

function s.eqoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,s.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,tc)
		
		if #tg>0 and Duel.Equip(tp,tc,tg:GetFirst()) then
			--恺撒在场时抽卡效果
			if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Draw(tp,1,REASON_EFFECT)
				Duel.BreakEffect()
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsCode(36700306)
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.eqtgfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsControler(tp)
end

function s.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqtgfilter2(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqtgfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqtgfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Equip(tp,c,tc)
	end
end
