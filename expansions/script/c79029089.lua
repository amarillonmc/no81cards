--罗德岛·近卫干员-赫拉格
function c79029089.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60417395,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c79029089.spcon)
	e2:SetCost(c79029089.spcost)
	e2:SetTarget(c79029089.sptg)
	e2:SetOperation(c79029089.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34408491,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DAMAGE+EVENT_RECOVER)
	e4:SetCondition(c79029089.atkcon)
	e4:SetOperation(c79029089.atkop)
	c:RegisterEffect(e4)
	--send to grave 
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c79029089.thtg)
	e5:SetOperation(c79029089.thop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,79029089)
	e6:SetTarget(c79029089.sptg1)
	e6:SetOperation(c79029089.spop1)
	c:RegisterEffect(e6)
	--recover
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(3701074,0))
	e7:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetTarget(c79029089.damtg)
	e7:SetOperation(c79029089.damop)
	c:RegisterEffect(e7)
end
function c79029089.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c79029089.cfilter1(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c79029089.cfilter2(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost()
end
function c79029089.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c79029089.cfilter1,tp,LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingMatchingCard(c79029089.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029089.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c79029089.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c79029089.cfilter2,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g4=Duel.SelectMatchingCard(tp,c79029089.cfilter2,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c79029089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029089.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function c79029089.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,LOCATION_EXTRA,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c79029089.thop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local b=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local p=b:GetCount()
	local q=a:GetCount()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_EXTRA,p,p,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_EXTRA,0,q,q,e:GetHandler())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	end
function c79029089.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	if bit.band(r,REASON_EFFECT)~=0 then return rp==1-tp end
	return e:GetHandler():IsRelateToBattle()
end
function c79029089.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c79029089.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029089.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,true,true,POS_FACEUP)
	end
end
function c79029089.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,bc:GetDefense())
end
function c79029089.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local def=bc:GetAttack()
	if def<0 then def=0 end
	Duel.Recover(tp,def,REASON_EFFECT,true)
	Duel.RDComplete()
end


