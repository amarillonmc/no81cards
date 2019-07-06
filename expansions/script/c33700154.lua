--甜蜜原型
function c33700154.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetTarget(c33700154.target)
	e1:SetOperation(c33700154.operation)
	c:RegisterEffect(e1)
	  --damage val
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c33700154.filter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsRace(0x445)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700154.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local rc=e:GetHandler():GetReasonCard()
   if chk==0 then return rc:GetAttack()>0 end
	local op
	if Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c33700154.filter,tp,LOCATION_DECK,0,1,nil,e,tp,rc:GetAttack()) then
	 op=Duel.SelectOption(tp,aux.Stringid(33700154,0),aux.Stringid(33700154,1))
	 else
	  op=Duel.SelectOption(tp,aux.Stringid(33700154,0))
end
   e:SetLabel(op)
	if op==0 then
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rc:GetAttack())
	else
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
end
function c33700154.operation(e,tp,eg,ep,ev,re,r,rp)
	 local rc=e:GetHandler():GetReasonCard()
	 if e:GetLabel()==0 then 
		Duel.Recover(tp,rc:GetAttack(),REASON_EFFECT)
	 else
   if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700154.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,rc:GetAttack())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
end