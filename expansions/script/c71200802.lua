--深渊的呼唤VIII 异动指针
local cm, m = GetID()
-------------------------------------------
Alter_DC8 = Alter_DC8 or {}
function Alter_DC8.Initial(cat,check,ex_op)
	cm.initial_effect = function(c)
		aux.AddCodeList(c,71200800)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,m)
		e1:SetCondition(Alter_DC8.Icon1)
		e1:SetTarget(Alter_DC8.Itg1)
		e1:SetOperation(Alter_DC8.Iop1)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON+cat)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,m+100)
		e2:SetTarget(Alter_DC8.Itg2(check))
		e2:SetOperation(Alter_DC8.Iop2(ex_op))
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(Alter_DC8.Icon2)
		c:RegisterEffect(e3)
	end
end
--e1
function Alter_DC8.Icon1f(c)
	return c:IsCode(71200800) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function Alter_DC8.Icon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Alter_DC8.Icon1f,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function Alter_DC8.Itg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function Alter_DC8.Iop1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
--e2
function Alter_DC8.Icon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function Alter_DC8.Itg2f1(c)
	return c:IsCode(71200800) and c:IsFaceup()
end
function Alter_DC8.Itg2f2(c,e,tp)
	return c:IsCode(71200800) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function Alter_DC8.Itg2(check)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local b=Duel.IsExistingMatchingCard(Alter_DC8.Itg2f1,tp,LOCATION_MZONE,0,1,nil)
		local g=Duel.GetMatchingGroup(Alter_DC8.Itg2f2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if chk==0 then return b and check(e,tp) or #g>0 end
	end
end
function Alter_DC8.Iop2(ex_op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(Alter_DC8.Itg2f1,tp,LOCATION_MZONE,0,1,nil) then 
			ex_op(e,tp)
			return 
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local c=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Alter_DC8.Itg2f2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if not c then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--------------------------------------------
if m ~= 71200802 then return end
function cm.chkf(c)
	return not c:IsCode(m) and c:IsSetCard(0x899) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.chk(e,tp)
	return Duel.IsExistingMatchingCard(cm.chkf,tp,LOCATION_DECK,0,1,nil)
end
function cm.ex_op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.chkf,tp,LOCATION_DECK,0,1,1,nil)
	if #g == 0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
Alter_DC8.Initial(CATEGORY_TOHAND,cm.chk,cm.ex_op)