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
--Show me the flowers
--aux.Stringid(id,0)="选择特殊召唤的怪兽"
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and g:CheckSubGroup(aux.dncheck,2,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then
		return
	end
	
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if not g:CheckSubGroup(aux.dncheck,2,2) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if not sg or #sg~=2 then return end
	
	-- 让对方选择一只怪兽
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,0))
	local tc=sg:Select(1-tp,1,1,nil):GetFirst()
	local oc=(sg-tc):GetFirst()
	
	-- 特殊召唤选择的怪兽到对方场上
	if Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
		-- 特殊召唤另一只怪兽到自己场上
		Duel.SpecialSummonStep(oc,0,tp,tp,false,false,POS_FACEUP)
	end
	
	Duel.SpecialSummonComplete()
end
