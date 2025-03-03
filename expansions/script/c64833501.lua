-- 替罪之子 摩斯迪露姆（64833501）
local s,id=GetID()

function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	c:RegisterEffect(e1)

	-- 效果2：强制融合召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.fustg)
	e2:SetOperation(s.fusop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

-- 条件判定
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	return Duel.GetMZoneCount(1-tp,nil,tp)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end

-- 目标区域验证
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	return #g<5 -- 确认对方主怪兽区有空位
end


-- 效果2：强制融合召唤（修正版）
function s.fusfilter(c,e,tp,mg)
	return c:IsSetCard(0x1419) and c:IsType(TYPE_FUSION) 
		and c:CheckFusionMaterial(mg,nil,tp)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		return Duel.IsExistingMatchingCard(s.fusfilter,tp,0,LOCATION_EXTRA,1,nil,e,1-tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local op=1-tp
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	
	-- 展示融合怪兽
	Duel.Hint(HINT_SELECTMSG,op,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(op,s.fusfilter,op,LOCATION_EXTRA,0,1,1,nil,e,op,mg):GetFirst()
	if not fc then return end
	Duel.ConfirmCards(tp,fc)
	
	-- 选择融合素材
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=Duel.SelectFusionMaterial(tp,fc,mg,nil,tp)
	
	-- 执行融合召唤
	fc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_FUSION+REASON_MATERIAL)
	Duel.BreakEffect()
	-- 特殊召唤到对方场上
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,op,op,false,false,POS_FACEUP)
	fc:CompleteProcedure()
	
	-- 丢弃手卡
	Duel.DiscardHand(op,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end