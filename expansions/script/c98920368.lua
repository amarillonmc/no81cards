--六武众的荒行者
function c98920368.initial_effect(c)
	c:SetUniqueOnField(1,0,98920368)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,2)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c98920368.indtg)
	e1:SetCondition(c98920368.damcon)
	e1:SetValue(c98920368.val)
	c:RegisterEffect(e1)
   --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920368,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c98920368.ocon2)
	e6:SetTarget(c98920368.otg2)
	e6:SetOperation(c98920368.oop2)
	c:RegisterEffect(e6)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920368,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c98920368.spcon)
	e5:SetTarget(c98920368.sptg)
	e5:SetOperation(c98920368.spop)
	c:RegisterEffect(e5)
end
function c98920368.val(e,c)
	return c:GetBaseAttack()
end
function c98920368.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c98920368.indtg(e,c)
	return c:IsSetCard(0x3d) and c~=e:GetHandler()
end
function c98920368.ocon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0x3d) and tc:IsRelateToBattle()
end
function c98920368.otg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920368.oop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(98920368,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c98920368.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98920368)~=0
end
function c98920368.filter(c,e,tp)
	return c:IsSetCard(0x3d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920368.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920368.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920368.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920368.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end