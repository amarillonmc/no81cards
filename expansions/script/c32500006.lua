--鲁路修&蜃气楼
--卡号：32500005
--反叛字段代码：0xa001

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--超量召唤：5星光・暗属性的战士族・魔法师族怪兽×2
	aux.AddXyzProcedure(c,s.xyzfilter,5,2)
	c:EnableReviveLimit()

	--①：超量召唤成功的场合，场上里侧表示的卡全部返回持有者卡组
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.tdcon1)
	e1:SetTarget(s.tdtg1)
	e1:SetOperation(s.tdop1)
	c:RegisterEffect(e1)

	--②：同列破坏，对方回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.desop2)
	c:RegisterEffect(e2)
end

--超量素材：5星光・暗属性的战士族・魔法师族怪兽
function s.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--①：超量召唤成功的场合
function s.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.tdfilter1(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end

function s.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tdfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end

function s.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

--②：以对方场上1张卡为对象
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp)
			and chkc:IsLocation(LOCATION_ONFIELD)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local dg=Group.CreateGroup()

	if tc then
		dg:AddCard(tc)
		local cg=tc:GetColumnGroup()
		if cg then
			cg=cg:Filter(s.colfilter2,nil,tp)
			dg:Merge(cg)
		end
	end

	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end

function s.colfilter2(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD)
end

function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end

	local dg=Group.CreateGroup()

	--那张卡
	if tc:IsRelateToEffect(e) then
		dg:AddCard(tc)
	end

	--和那张卡同列的对方的卡
	local cg=tc:GetColumnGroup()
	if cg then
		cg=cg:Filter(s.colfilter2,nil,tp)
		dg:Merge(cg)
	end

	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end