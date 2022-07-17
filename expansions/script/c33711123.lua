--【月】静海上的蜜月
local m=33711123
local cm=_G["c"..m]
function cm.initial_effect(c)
	--back
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.backon)
	e0:SetOperation(cm.backop)
	c:RegisterEffect(e0)
--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTarget(cm.reptg)
		e1:SetValue(cm.repval)
		c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCondition(cm.condition1)
	e4:SetTarget(cm.target1)
	e4:SetOperation(cm.operation1)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCondition(cm.condition2)
	e5:SetTarget(cm.target2)
	e5:SetOperation(cm.operation2)
	c:RegisterEffect(e5)
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==m
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(m-3)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(m-3,0,0)
	Duel.Hint(HINT_CARD,1,m-3)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp/2)
		return true
	else return false end
end
function cm.repval(e,c)
	return true
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not ((c:IsRank(5) or c:IsLevel(5)) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_EARTH)) and se:GetHandler()~=e:GetHandler()
end
function cm.check(c)
	return c:IsFacedown() or not c:IsSetCard(0x440)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.check,tp,LOCATION_MZONE,0,nil)==0
end
function cm.filter(c,e,tp)
	return ((c:IsSetCard(0x441) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(5)) or c:IsSetCard(0x3440) or c:IsCode(33700035,33701066)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if Duel.Recover(tp,atk+def,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function cm.check1(c)
	return c:IsFaceup() and c:IsSetCard(0x441)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.check1,tp,LOCATION_MZONE,0,nil)>0
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x441) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		if Duel.Recover(tp,atk,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local g=Duel.GetMatchingGroup(cm.check1,tp,LOCATION_MZONE,0,nil)
			for tc in aux.Next(g) do
				tc:AddCounter(0x1021,2)
			end
		end
	end
end
function cm.check2(c)
	return c:IsFaceup() and c:IsSetCard(0x3440)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.check2,tp,LOCATION_MZONE,0,nil)>0
end
function cm.filter2(c,e,tp)
	return c:IsSetCard(0x6440) and c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,2,nil,e,tp)
	if g:GetCount()>0 then
		local atk=g:GetSum(Card.GetAttack)
		if Duel.Recover(tp,atk,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end