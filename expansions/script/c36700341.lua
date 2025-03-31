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
--"NO NO Happy Birthday"
--aux.Stringid(id,0)="丢弃手卡并抽卡"

local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Filter for "Fire's Dawn" monsters
function s.fdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end

-- Check activation condition
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.fdfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=2
end

-- Activation limit
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(id) and not re:GetHandler()==e:GetHandler()
end

-- Target selection
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER)
		and Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_MZONE,1,1,nil,TYPE_MONSTER)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end

-- Card effect activation
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local ct=math.min(2,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
			if ct>0 then
				local disct=Duel.DiscardHand(tp,nil,1,ct,REASON_EFFECT+REASON_DISCARD)
				Duel.Draw(tp,disct,REASON_EFFECT)
			end
		end
		
		--Battle destruction protection
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
	end
end
