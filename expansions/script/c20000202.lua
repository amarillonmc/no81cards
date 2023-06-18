--红莲武士 爱菈
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2(cm.op2ex))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op2(cm.op3ex))
	c:RegisterEffect(e3)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.NegateAttack() and c:IsRelateToEffect(e)) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function cm.tg2f(c,e,tp)
	return c:IsSetCard(0x6fd2) and c:IsLevel(5) and c:GetType()&0x81==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.tg2f,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op2(exop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.tg2f,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if not (c:IsRelateToEffect(e) and tc) then return end
		tc:SetMaterial(Group.FromCards(c))
		Duel.ReleaseRitualMaterial(Group.FromCards(c))
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		exop(e,tp,eg,ep,ev,re,r,rp,c,tc)
	end
end
function cm.op2ex(e,tp,eg,ep,ev,re,r,rp,c,tc)
	if Duel.GetAttacker():IsImmuneToEffect(e) or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.BreakEffect()
	Duel.ChangeAttackTarget(tc)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:GetHandler():IsSetCard(0x5fd2) then Duel.Hint(24,0,aux.Stringid(m,0)) end
	return g and g:IsContains(e:GetHandler())
end
function cm.op3ex(e,tp,eg,ep,ev,re,r,rp,c,tc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not (#g==1 and g:GetFirst()==c and Duel.CheckChainTarget(ev,tc) and Duel.SelectYesNo(tp,aux.Stringid(m,2))) then return end
	Duel.BreakEffect()
	Duel.ChangeTargetCard(ev,Group.FromCards(tc))
end