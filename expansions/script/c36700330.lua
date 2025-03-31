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
--言灵 镰鼬
--aux.Stringid(id,0)="宣言怪兽"
--aux.Stringid(id,1)="宣言魔法"
--aux.Stringid(id,2)="宣言陷阱"
--aux.Stringid(id,3)="是否禁止发动"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700306)
	
	--Quick-play, guess card types
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	if not s.global_flag then
		s.global_flag=true
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e2:SetRange(0xff)
		e2:SetCondition(s.con)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,id))
		e2:SetTargetRange(LOCATION_HAND,0)
		c:RegisterEffect(e2)
	
	end

end

function s.ksrfilter(c)
	return c:IsFaceup() and c:IsCode(36700306)
end

function s.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFacedown())
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,0,LOCATION_HAND+LOCATION_SZONE,nil)
		return ct>0 and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_HAND+LOCATION_SZONE,nil)
	if #g<=0 then return end
	
	local ct=#g
	local correct=0
	local tdisable={}
	
	for i=1,ct do
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		
		local opt={}
		local opval={}
		table.insert(opt,aux.Stringid(id,0))
		table.insert(opval,TYPE_MONSTER)
		table.insert(opt,aux.Stringid(id,1))
		table.insert(opval,TYPE_SPELL)
		table.insert(opt,aux.Stringid(id,2))
		table.insert(opval,TYPE_TRAP)
		
		local declaredType=opval[Duel.SelectOption(tp,table.unpack(opt))+1]
		
		Duel.ConfirmCards(tp,tc)
		if (declaredType==TYPE_MONSTER and tc:IsType(TYPE_MONSTER)) 
			or (declaredType==TYPE_SPELL and tc:IsType(TYPE_SPELL)) 
			or (declaredType==TYPE_TRAP and tc:IsType(TYPE_TRAP)) then
			correct=correct+1
			table.insert(tdisable,tc)
		end
		
		if tc:IsLocation(LOCATION_HAND) then
			Duel.ShuffleHand(1-tp)
		else
			tc:CreateEffectRelation(e)
		end
	end
	
	if correct>0 then
		Duel.Draw(tp,correct,REASON_EFFECT)
		
		if Duel.IsExistingMatchingCard(s.ksrfilter,tp,LOCATION_MZONE,0,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			for _,tc in ipairs(tdisable) do
				if tc:IsLocation(LOCATION_SZONE) and tc:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsControler(1-tp) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				elseif tc:IsLocation(LOCATION_HAND) and tc:IsControler(1-tp) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ksrfilter,tp,LOCATION_MZONE,0,1,nil)
end
