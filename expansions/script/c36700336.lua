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
--屠龙剑域
--aux.Stringid(id,0)="特殊召唤火之晨曦怪兽"
--aux.Stringid(id,1)="连接召唤火之晨曦连接怪兽"

local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--Special summon from GY when opponent summons
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	
	--Link Summon on opponent effect activation
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.lkcon)
	e2:SetTarget(s.lktg)
	e2:SetOperation(s.lkop)
	c:RegisterEffect(e2)
	
	--Change opponent monsters to Dragon + reduce ATK
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_CHANGE_RACE)
	e3a:SetRange(LOCATION_SZONE)
	e3a:SetTargetRange(0,LOCATION_MZONE)
	e3a:SetValue(RACE_DRAGON)
	c:RegisterEffect(e3a)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_FIELD)
	e3b:SetCode(EFFECT_UPDATE_ATTACK)
	e3b:SetRange(LOCATION_SZONE)
	e3b:SetTargetRange(0,LOCATION_MZONE)
	e3b:SetTarget(s.atktg)
	e3b:SetValue(-500)
	c:RegisterEffect(e3b)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.lkfilter(c,mg)
	return c:IsSetCard(0xc50) and c:IsLinkSummonable(nil,mg,nil,nil,nil,2)
end

function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsCanBeLinkMaterial),tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsCanBeLinkMaterial),tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,mg)
	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		
		Duel.LinkSummon(tp,sc,nil,mg,nil,nil,nil,2)
		
		if sc:IsLocation(LOCATION_MZONE) then
			-- Cannot be destroyed by effects
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end

function s.atktg(e,c)
	return c:IsRace(RACE_DRAGON)
end