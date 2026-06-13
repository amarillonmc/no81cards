--反叛 弑神之剑
--卡号：32500022
--反叛字段代码：0xa001
--速攻魔法

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--①：无效并破坏自己场上1只对应怪兽和对方场上1张卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.destg1)
	e1:SetOperation(s.desop1)
	c:RegisterEffect(e1)

	--②：自己从额外卡组特殊召唤对应怪兽的场合，墓地的这张卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon2)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)
end

--光・暗属性的战士族・魔法师族怪兽
function s.monfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--①：自己场上1只表侧表示的光・暗属性的战士族・魔法师族怪兽
function s.ownfilter1(c)
	return c:IsFaceup()
		and s.monfilter(c)
		and c:IsCanBeEffectTarget()
end

--①：对方场上1张表侧表示的卡
--限定表侧表示，否则“效果无效”无法正常处理
function s.oppfilter1(c)
	return c:IsFaceup()
		and c:IsCanBeEffectTarget()
end

function s.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(s.ownfilter1,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(s.oppfilter1,tp,0,LOCATION_ONFIELD,1,nil)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,s.ownfilter1,tp,LOCATION_MZONE,0,1,1,nil)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,s.oppfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)

	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end

--无效表侧表示卡的效果
function s.negate_card(tc,e)
	if not (tc and tc:IsFaceup()) then return end

	Duel.NegateRelatedChain(tc,RESET_TURN_SET)

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)

	--陷阱怪兽兼容
	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		tc:RegisterEffect(e3)
	end
end

function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end

	local dg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsRelateToEffect(e) then
			--表侧表示则先无效
			if tc:IsFaceup() then
				s.negate_card(tc,e)
			end
			--无效后重新判断是否可破坏
			if tc:IsDestructable() then
				dg:AddCard(tc)
			end
		end
	end

	--那些卡破坏
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end

	--这个效果发动后，直到回合结束时自己不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

--②：自己从额外卡组将光・暗属性的战士族・魔法师族怪兽特殊召唤的场合
function s.cfilter2(c,tp)
	return c:IsControler(tp)
		and c:IsSummonLocation(LOCATION_EXTRA)
		and s.monfilter(c)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp)
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end

function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

--自肃：不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(SPELLCASTER)))
end