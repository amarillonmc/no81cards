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

--烈火再燃
local s,id,o=GetID()
function s.initial_effect(c)
	--只能发动1张
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.rlfilter(c,e,tp)
	return c:IsReleasableByEffect() and c:IsFaceup()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.thfilter(c,e,tp)
	return c:IsSetCard(0xc50) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(s.rlfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	
	if chkc then
		if e:GetLabel()==1 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.rlfilter(chkc,e,tp)
		else
			return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc,e,tp)
		end
	end
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op+1)
	
	if op==0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectTarget(tp,s.rlfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	if e:GetLabel()==1 then
		if Duel.Release(tc,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
