--反叛 神之意志
--卡号：32500024
--反叛字段代码：0xa001
--反击陷阱

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--①：对方把怪兽召唤之际，那个召唤无效，那些怪兽破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCost(s.negcost1)
	e1:SetCondition(s.negcon1)
	e1:SetTarget(s.negtg1)
	e1:SetOperation(s.negop1)
	c:RegisterEffect(e1)

	--①：对方把怪兽特殊召唤之际，那个特殊召唤无效，那些怪兽破坏
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e1b)

	--②：墓地除外自身，抽2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.drcost2)
	e2:SetCondition(s.drcon2)
	e2:SetTarget(s.drtg2)
	e2:SetOperation(s.drop2)
	c:RegisterEffect(e2)
end

--光・暗属性的战士族・魔法师族怪兽
function s.monfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--① cost：把墓地1张「反叛」卡除外
function s.costfilter1(c)
	return c:IsSetCard(SET_REBELLION)
		and c:IsAbleToRemoveAsCost()
end

function s.negcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--① condition：对方把怪兽召唤・特殊召唤之际
function s.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
		and Duel.GetCurrentChain()==0
end

function s.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

--② condition：对方手卡数量比自己的手卡数量与自己场上的卡数量合计多3张以上
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local opp_hand=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local my_hand=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local my_field=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return opp_hand >= my_hand + my_field + 3
end

--② cost：把墓地的这张卡除外
function s.drcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)>0 then
		--这个效果发动后，直到回合结束时自己不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

--自肃：不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)))
end