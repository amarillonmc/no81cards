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

--火之晨曦之门-卡塞尔学院
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.thfilter(c)
	return c:IsSetCard(0xc50) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.monfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER)
end

function s.stfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end

function s.stfilter2(c)
	return c:IsSetCard(0xc50) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end

function s.monfilter2(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(s.monfilter,tp,LOCATION_MZONE,0,1,nil) and
		Duel.IsExistingMatchingCard(s.stfilter2,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(s.stfilter,tp,LOCATION_SZONE,0,1,nil) and
		Duel.IsExistingMatchingCard(s.monfilter2,tp,LOCATION_DECK,0,1,nil)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=0
	else
		op=1
	end
	
	e:SetLabel(op)
	
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.monfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.stfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	
	local op=e:GetLabel()
	
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.stfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.monfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--提示词索引说明：
--id,0: "加入手卡?"
--id,1: "加入手卡"
--id,2: "对象怪兽，检索魔法陷阱"
--id,3: "对象魔法陷阱，检索怪兽"
