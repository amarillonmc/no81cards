--根源之造化形兽
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_CARBON_CRAB=21401292

function s.initial_effect(c)
	aux.AddCodeList(c,CARD_CARBON_CRAB)

	--① 从卡组把1只「化形兽」怪兽加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--② 对方怪兽效果发动的场合，墓地变怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

--==============================
-- ① 检索「化形兽」怪兽
--==============================
function s.thfilter(c)
	return c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--==============================
-- ② 对方怪兽效果发动的场合，墓地变怪兽
--==============================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
		and re:IsActivated()
		and re:IsActiveType(TYPE_MONSTER)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and aux.NecroValleyFilter()(c)
			and Duel.IsPlayerCanSpecialSummonMonster(
				tp,
				CARD_CARBON_CRAB,
				SET_METAFORM,
				TYPE_MONSTER+TYPE_NORMAL,
				700,
				1400,
				4,
				RACE_AQUA,
				ATTRIBUTE_FIRE
			)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not aux.NecroValleyFilter()(c) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(
		tp,
		CARD_CARBON_CRAB,
		SET_METAFORM,
		TYPE_MONSTER+TYPE_NORMAL,
		700,
		1400,
		4,
		RACE_AQUA,
		ATTRIBUTE_FIRE
	) then return end

	--先让这张魔法卡具备怪兽属性，才能作为怪兽特殊召唤
	c:AddMonsterAttribute(TYPE_NORMAL)

	--SpecialSummonStep 成功后、Complete 前注册完整状态
	if not Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then return end
	s.register_stmonster_effects(c)
	Duel.SpecialSummonComplete()

	--那之后，可以融合召唤
	if s.fusion_check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		s.fusion_op(e,tp)
	end
end

function s.register_stmonster_effects(c)
	--不当作魔法卡使用，变成通常怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)

	--卡名当作「化形兽 碳素蟹」
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(CARD_CARBON_CRAB)
	c:RegisterEffect(e2,true)

	--水族
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_AQUA)
	c:RegisterEffect(e3,true)

	--炎属性
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e4,true)

	--4星
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(4)
	c:RegisterEffect(e5,true)

	--原本攻击力700
	local e6=e1:Clone()
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetValue(700)
	c:RegisterEffect(e6,true)

	--原本守备力1400
	local e7=e1:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(1400)
	c:RegisterEffect(e7,true)

	--从场上离开的场合回到卡组
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e8:SetValue(LOCATION_DECK)
	e8:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e8,true)
end

--==============================
-- 可选融合召唤：手卡·场上怪兽作为素材
--==============================
function s.fusfilter(c,e,tp,mg)
	return c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(mg,nil,tp)
end

function s.fusion_check(e,tp)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end

function s.fusion_op(e,tp)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	if #mg==0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local fc=sg:GetFirst()
	if not fc then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=Duel.SelectFusionMaterial(tp,fc,mg,nil,tp)
	if not mat or #mat==0 then return end

	fc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	fc:CompleteProcedure()
end
