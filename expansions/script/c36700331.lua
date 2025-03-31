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
--言灵 君焰
--aux.Stringid(id,0)="选择1只炎属性怪兽"
--aux.Stringid(id,1)="给予伤害"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700313)
	
	--Normal Trap, can activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--Activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

function s.czhfilter(c)
	return c:IsFaceup() and c:IsCode(36700313)
end

function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.czhfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end

function s.desfilter(c)
	return c:IsFaceup() and c:IsDefenseBelow(3000)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local success=false
	
	if tc:IsRelateToEffect(e) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,2))and Duel.SendtoHand(tc,nil,REASON_EFFECT) then
			success=true
		end
		if success then
			local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
				local ag=Duel.GetOperatedGroup()
				local max_atk=ag:GetMaxGroup(s.atkfilter)
				if max_atk>0 and Duel.IsExistingMatchingCard(s.czhfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					Duel.Damage(1-tp,max_atk,REASON_EFFECT)
				end
		
			end
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetOperation(s.desop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)

		end
	end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
		local ag=Duel.GetOperatedGroup()
		local max_atk=ag:GetMaxGroup(s.atkfilter)
		if max_atk>0 and Duel.IsExistingMatchingCard(s.czhfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,max_atk,REASON_EFFECT)
		end

	end
end
function s.atkfilter(c) 
	return c:GetBaseAttack()
end