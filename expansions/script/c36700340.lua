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
--罪与罚
--aux.Stringid(id,0)="特殊召唤火之晨曦怪兽"

local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--Special Summon when a "Fire's Dawn" monster leaves the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--No damage and battle destruction protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.efilter)
	e2:SetValue(1)
	e2:SetCondition(s.protcon)
	c:RegisterEffect(e2)
	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetTargetRange(LOCATION_MZONE,0)
	e2b:SetTarget(s.fdfilter)
	e2b:SetValue(1)
	e2b:SetCondition(s.protcon)
	c:RegisterEffect(e2b)
	
	--Negate Dragon-Type monster effects
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_DISABLE)
	e3a:SetRange(LOCATION_SZONE)
	e3a:SetTargetRange(0,LOCATION_MZONE)
	e3a:SetTarget(s.drgtg)
	c:RegisterEffect(e3a)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_FIELD)
	e3b:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b:SetRange(LOCATION_SZONE)
	e3b:SetTargetRange(0,1)
	e3b:SetValue(s.aclimit)
	c:RegisterEffect(e3b)
end

-- Check if a "Fire's Dawn" monster left the field
function s.cfilter(c,e,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsSetCard(0xc50) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.cfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g and #g>0 end
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,g:GetFirst():GetLocation())
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:CheckSubGroup(s.cfilter,1,1,e,tp)
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

-- Filter for "Fire's Dawn" monsters
function s.fdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end

-- Filter for "Seven Deadly Sins, Lust" and "Luminous, Fire's Dawn"
function s.luxfilter(c)
	return c:IsFaceup() and c:IsCode(36700353) -- 七宗罪·色欲
end

function s.lmffilter(c)
	return c:IsFaceup() and c:IsCode(36700304) -- 路明非 火之晨曦
end

-- Filter for Link-3 or higher "Fire's Dawn" monsters
function s.link3filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_LINK) and c:GetLink()>=3
end

-- Protection condition check
function s.protcon(e)
	local tp=e:GetHandlerPlayer()
	return (Duel.IsExistingMatchingCard(s.luxfilter,tp,LOCATION_ONFIELD,0,1,nil) and
		Duel.IsExistingMatchingCard(s.lmffilter,tp,LOCATION_ONFIELD,0,1,nil)) or
		Duel.IsExistingMatchingCard(s.link3filter,tp,LOCATION_MZONE,0,1,nil)
end

-- Effect target for damage avoidance
function s.efilter(e,c)
	return true -- All player damage becomes 0
end

-- Dragon-type monster filter
function s.drgtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end

-- Activation limit for Dragon-type monster effects
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DRAGON)
end