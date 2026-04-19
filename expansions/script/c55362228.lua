-- 巨石遗物馈赠（唯一Token素材·完全稳定版）
local s,id=GetID()
function s.initial_effect(c)
	-- ①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOGRAVE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 堆墓
function s.tgfilter(c,e,tp)
	return c:IsSetCard(0x138) and c:IsLevelBelow(8) and c:IsAbleToGrave()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x138,TYPES_TOKEN_MONSTER,0,0,c:GetLevel(),c:GetRace(),c:GetAttribute(),POS_FACEUP_DEFENSE)
end

-- 仪式筛选（严格=Token等级）
function s.ritfilter(c,e,tp,lv)
	return c:IsSetCard(0x138) and c:IsType(TYPE_RITUAL)
		and c:GetLevel()==lv
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end

	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end

	-- 记录属性
	local lv=tc:GetLevel()
	local rc=tc:GetRace()
	local att=tc:GetAttribute()

	-- 创建Token
	local token=Duel.CreateToken(tp,id+1)

	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		-- 等级
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)

		-- 种族
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(rc)
		token:RegisterEffect(e2)

		-- 属性
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(att)
		token:RegisterEffect(e3)

		-- 素材限制
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e4:SetValue(1)
		token:RegisterEffect(e4)

		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e5)

		local e6=e4:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e6)
	end
	Duel.SpecialSummonComplete()

	-- 仪式处理
	Duel.BreakEffect()

	-- 只允许等于Token等级的仪式怪
	local ritg=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c)
		return s.ritfilter(c,e,tp,lv)
	end),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)

	if #ritg==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=ritg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end

	-- ⭐关键修复：只检查是否在场
	if not token or not token:IsOnField() then return end

	-- ⭐必须用Group
	local mat=Group.FromCards(token)
	sc:SetMaterial(mat)

	Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)

	Duel.BreakEffect()

	if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end