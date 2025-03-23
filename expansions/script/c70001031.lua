--帝王的指命
local m=70001031
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+2)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	--Activate3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+3)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.target3)
	e3:SetOperation(cm.activate3)
	c:RegisterEffect(e3)
end
	function cm.con(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
	function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,70001032,0,TYPES_TOKEN_MONSTER,800,1000,1,RACE_FIEND,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
	function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,70001032,0,TYPES_TOKEN_MONSTER,800,1000,1,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,70001032)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	--double tribute
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(cm.dtcon)
	token:RegisterEffect(e1,true)
end
	function cm.dtcon(e,c)
	return c:IsAttackAbove(2400)
end
	function cm.dfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
	function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetMatchingGroupCount(cm.dfilter,0,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
	function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetMatchingGroupCount(cm.dfilter,0,LOCATION_MZONE,0,nil)
	if Duel.SortDecktop(tp,tp,d)~=0 then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end
	function cm.rfilter(c)
	return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
	function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
	function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	if g2:GetCount()>0  and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		end
	end
end