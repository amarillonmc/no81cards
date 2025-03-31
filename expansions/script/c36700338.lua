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
--诺顿 火之晨曦
--aux.Stringid(id,0)="破坏对方场上的卡"
--aux.Stringid(id,1)="复制火之晨曦怪兽"
--aux.Stringid(id,2)="特殊召唤路明非"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700348,36700304)
	
	--Link Summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,3,5,s.lcheck)
	
	--spsum condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	
	--Destroy all cards on opponent's field when summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	--Copy name and effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
	--Special summon "Luminous, Fire's Dawn" when leaving the field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	s.effect_2=e2

end

-- Link material filter
function s.matfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end

-- Check if materials include "Constantine, Fire's Dawn"
function s.lcheck(g)
	return g:IsExists(Card.IsCode,1,nil,36700348) and aux.dncheck(g)
end

-- Destroy effect target
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- Destroy effect operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-- Copy effect filter
function s.cpfilter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end

-- Copy effect target
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
end

-- Copy effect operation
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

-- Special summon filter
function s.spfilter(c,e,tp)
	return c:IsCode(36700304) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

-- Special summon target
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- 必发效果，总是返回true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end

-- Special summon operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end