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
--言灵 时间零
--aux.Stringid(id,0)="选择表侧表示怪兽"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700350)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.ahfilter(c)
	return c:IsFaceup() and c:IsCode(36700350)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_CONFIRM)
	e0:SetCondition(s.tgcon)
	e0:SetOperation(s.tgop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(tc)
	e0:SetLabel(tc:GetFieldID())
	Duel.RegisterEffect(e0,tp)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(s.ahfilter,tp,LOCATION_MZONE,0,1,nil) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(0,LOCATION_ONFIELD)
		e2:SetTarget(s.distg)
		e2:SetCondition(s.discon)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

-- 限制对手的连锁效果
function s.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and 
	       Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT):GetHandler()==tc
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
	local fid=e:GetLabel()
    local bc=tc:GetBattleTarget()
    -- 确保目标怪兽和对方怪兽都存在且在战斗后仍在场上
    return tc:IsRelateToBattle() and bc and bc:IsControler(1-tp) and bc:IsRelateToBattle() and tc:GetFieldID()==fid
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local oppc=nil
	
	if a==tc and d and d:IsControler(1-tp) then
		oppc=d
	elseif d==tc and a:IsControler(1-tp) then
		oppc=a
	end
	
	if oppc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_CALCULATING)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetOperation(s.damop)
		e1:SetLabelObject(oppc)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local oppc=e:GetLabelObject()
	if oppc and oppc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetLabelObject(oppc)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetLabelObject()
			if tc and tc:IsRelateToBattle() then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.discon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end

function s.distg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end