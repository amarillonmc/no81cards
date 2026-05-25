--化形兽的明堂
local s,id,o=GetID()
local SET_METAFORM=0x9D71

function s.initial_effect(c)
	--① 发动时适用：追加召唤权
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--② 这张卡以外的魔法·陷阱卡发动的场合
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--③ 这张卡从场上离开的场合，墓地·除外怪兽回卡组/额外融合召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.fuscon)
	e3:SetTarget(s.fustg)
	e3:SetOperation(s.fusop)
	c:RegisterEffect(e3)
end

--==============================
-- ① 追加1次「化形兽」召唤
--==============================
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(s.sumtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.sumtg(e,c)
	return c:IsSetCard(SET_METAFORM) and c:IsType(TYPE_MONSTER)
end

--==============================
-- ② 魔陷发动后，这张卡变通常怪兽特殊召唤
--==============================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler()~=e:GetHandler()
end

function s.pendfilter(c,e,tp)
	if not c:IsSetCard(SET_METAFORM) then return false end
	if not c:IsType(TYPE_MONSTER) or not c:IsType(TYPE_PENDULUM) then return false end
	if not c:IsAbleToExtra() then return false end
	if c:IsLocation(LOCATION_GRAVE) and not aux.NecroValleyFilter()(c) then return false end

	local code=c:GetOriginalCode()
	local race=c:GetOriginalRace()
	local attr=c:GetOriginalAttribute()
	local lv=c:GetOriginalLevel()
	local atk=c:GetTextAttack()
	local def=c:GetTextDefense()

	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(
			tp,
			code,
			SET_METAFORM,
			TYPE_MONSTER+TYPE_NORMAL,
			atk,
			def,
			lv,
			race,
			attr
		)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.pendfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_FZONE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g=Duel.SelectMatchingCard(tp,s.pendfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_GRAVE) and not aux.NecroValleyFilter()(tc) then return end

	local code=tc:GetOriginalCode()
	local race=tc:GetOriginalRace()
	local attr=tc:GetOriginalAttribute()
	local lv=tc:GetOriginalLevel()
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()

	if Duel.SendtoExtraP(g,tp,REASON_EFFECT)==0 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(
		tp,
		code,
		SET_METAFORM,
		TYPE_MONSTER+TYPE_NORMAL,
		atk,
		def,
		lv,
		race,
		attr
	) then return end

	--关键：先用所选灵摆怪兽的原本参数赋予怪兽属性，再进行特殊召唤。
	c:AddMonsterAttribute(TYPE_NORMAL,attr,race,lv,atk,def)

	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
		s.register_field_monster_effects(c,code,race,attr,lv,atk,def)
	end
	Duel.SpecialSummonComplete()
end

function s.register_field_monster_effects(c,code,race,attr,lv,atk,def)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(code)
	c:RegisterEffect(e2,true)

	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(race)
	c:RegisterEffect(e3,true)

	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(attr)
	c:RegisterEffect(e4,true)

	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(lv)
	c:RegisterEffect(e5,true)

	local e6=e1:Clone()
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetValue(atk)
	c:RegisterEffect(e6,true)

	local e7=e1:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(def)
	c:RegisterEffect(e7,true)
end

--==============================
-- ③ 离场后，墓地·除外怪兽回卡组/额外融合召唤
--==============================
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.matfilter(c)
	return c:IsType(TYPE_MONSTER)
		and c:IsAbleToDeck()
		and (not c:IsLocation(LOCATION_GRAVE) or aux.NecroValleyFilter()(c))
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.fusfilter(c,e,tp,mg)
	return c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_FUSION)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(mg,nil,tp)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then
		return #mg>0
			and Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #mg==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local fc=sg:GetFirst()
	if not fc then return end
	if Duel.GetLocationCountFromEx(tp,tp,nil,fc)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=Duel.SelectFusionMaterial(tp,fc,mg,nil,tp)
	if not mat or #mat==0 then return end
	if not fc:CheckFusionMaterial(mat,nil,tp) then return end

	fc:SetMaterial(mat)
	local ct=Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	if ct<#mat then return end

	Duel.BreakEffect()
	if Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
		fc:CompleteProcedure()
	end
end
