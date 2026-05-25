--反叛 黑色骑士团
--卡号：32500020
--反叛字段代码：0xa001
--永续魔法

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：以自己场上1只阶级4的对应超量怪兽为对象，升阶/降阶超量召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.sharedcost)
	e1:SetTarget(s.xyztg1)
	e1:SetOperation(s.xyzop1)
	c:RegisterEffect(e1)

	--②：自己场上的对应怪兽成为卡的效果对象的场合，从卡组特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(s.sharedcost)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

--这张卡的①②的效果1回合只能有1次使用其中任意1个
function s.sharedcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id)==0
	end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

--光・暗属性的战士族・魔法师族怪兽
function s.monfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--①：自己场上1只阶级4的光・暗属性的战士族・魔法师族超量怪兽
function s.xyzmatfilter1(c)
	return c:IsFaceup()
		and c:IsType(TYPE_XYZ)
		and c:GetRank()==4
		and s.monfilter(c)
end

--额外卡组中比对象怪兽阶级高1或低1的对应超量怪兽
function s.xyzfilter1(c,e,tp,tc)
	local r=tc:GetRank()
	return c:IsType(TYPE_XYZ)
		and s.monfilter(c)
		and (c:GetRank()==r+1 or c:GetRank()==r-1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end

function s.xyztg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE)
			and s.xyzmatfilter1(chkc)
			and Duel.IsExistingMatchingCard(s.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.xyzmatfilter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xyzmatfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.xyzop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if not Duel.IsExistingMatchingCard(s.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.xyzfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local xyz=g:GetFirst()
	if not xyz then return end

	--将原本的超量素材转移到新超量怪兽下面
	local og=tc:GetOverlayGroup()
	if #og>0 then
		Duel.Overlay(xyz,og)
	end

	--在作为对象的怪兽上面重叠
	Duel.Overlay(xyz,Group.FromCards(tc))

	--当作超量召唤特殊召唤
	Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	xyz:CompleteProcedure()
end

--②：自己场上的光・暗属性的战士族・魔法师族怪兽成为卡的效果对象
function s.tgfilter2(c,tp)
	return c:IsControler(tp)
		and c:IsLocation(LOCATION_MZONE)
		and s.monfilter(c)
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return re
		and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and eg:IsExists(s.tgfilter2,1,nil,tp)
end

--②：从卡组特殊召唤用
function s.spfilter2(c,e,tp)
	return s.monfilter(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end