--D-旅团 作战
local m=40011318
local cm=_G["c"..m]
cm.named_with_DBrigade=1
function cm.DBrigade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DBrigade
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--decrease atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
end
function cm.filter(c,e,tp)
	return cm.DBrigade(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.tdfilter(c)
	return cm.DBrigade(c)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end

	local tg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)

	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local dg=tg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(dg:GetFirst(),SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function cm.atkfilter(c)
	return c:IsFaceup() and cm.DBrigade(c)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-200
end