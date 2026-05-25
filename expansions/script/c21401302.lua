--蚀销之造化形兽
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290

function s.initial_effect(c)
	aux.AddCodeList(c,CARD_HYDROGEN_EAGLE)

	--全局记录：自己的融合怪兽在主要阶段从场上离开
	if not s.global_check then
		s.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_LEAVE_FIELD)
		ge:SetOperation(s.checkop)
		Duel.RegisterEffect(ge,0)
	end

	--① 反击陷阱：发动无效并破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)

	--盖放回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(s.actsetcon)
	c:RegisterEffect(e2)

	--② 墓地变成通常怪兽特殊召唤，那之后可以融合召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

--==============================
-- 盖放回合可发动记录
--==============================
function s.leftfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:GetPreviousTypeOnField()&TYPE_FUSION)~=0
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_MAIN1 and ph~=PHASE_MAIN2 then return end
	for p=0,1 do
		if eg:IsExists(s.leftfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,id+100,RESET_PHASE+ph,0,1)
		end
	end
end

function s.actsetcon(e)
	local tp=e:GetHandlerPlayer()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.GetFlagEffect(tp,id+100)>0
end

--==============================
-- ① 发动无效并破坏
--==============================
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainNegatable(ev)
end

function s.costfilter(c)
	return c:IsFaceup()
		and c:IsSetCard(SET_METAFORM)
		and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
		and (not c:IsLocation(LOCATION_GRAVE) or aux.NecroValleyFilter()(c))
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(
			s.costfilter,
			tp,
			LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,
			0,
			1,
			nil
		)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(
		tp,
		s.costfilter,
		tp,
		LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,
		0,
		1,
		1,
		nil
	)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end

--==============================
-- ② 「化形兽」卡效果发动时，墓地变怪兽
--==============================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActivated()
		and rc:IsSetCard(SET_METAFORM)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and aux.NecroValleyFilter()(c)
			and Duel.IsPlayerCanSpecialSummonMonster(
				tp,
				CARD_HYDROGEN_EAGLE,
				SET_METAFORM,
				TYPES_NORMAL_TRAP_MONSTER,
				1400,
				700,
				4,
				RACE_WINDBEAST,
				ATTRIBUTE_FIRE
			)
			and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
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
		CARD_HYDROGEN_EAGLE,
		SET_METAFORM,
		TYPES_NORMAL_TRAP_MONSTER,
		1400,
		700,
		4,
		RACE_WINDBEAST,
		ATTRIBUTE_FIRE
	) then return end

	--先让这张陷阱卡具备怪兽属性，才能作为怪兽特殊召唤
	c:AddMonsterAttribute(TYPE_NORMAL)

	--SpecialSummonStep 成功后、Complete 前注册卡名/种族/属性/等级/攻守/离场回卡组
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
	--不当作陷阱卡使用，变成通常怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)

	--卡名当作「化形兽 氢素鹰」使用
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(CARD_HYDROGEN_EAGLE)
	c:RegisterEffect(e2,true)

	--鸟兽族
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_WINDBEAST)
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

	--原本攻击力1400
	local e6=e1:Clone()
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetValue(1400)
	c:RegisterEffect(e6,true)

	--原本守备力700
	local e7=e1:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(700)
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
