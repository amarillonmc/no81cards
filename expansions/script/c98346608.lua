--东方的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf7),aux.NonTuner(Card.IsSetCard,0xaf7),1)
	c:EnableReviveLimit()
	--ccpos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	c:RegisterEffect(e1)
	--unsynchroable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346608,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98346608.spcon)
	e3:SetTarget(c98346608.sptg)
	e3:SetOperation(c98346608.spop)
	c:RegisterEffect(e3)
	--position change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98346608,1))
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(c98346608.postg)
	e4:SetOperation(c98346608.posop)
	c:RegisterEffect(e4)
end
function c98346608.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98346608.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xaf7) and c:IsLevelBelow(7)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c98346608.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98346608.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98346608.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c98346608.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end
function c98346608.filter(c)
	return c:IsCanChangePosition()
end
function c98346608.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98346608.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c98346608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c98346608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c98346608.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 
			and (tc:IsControler(tp) or Duel.IsPlayerCanDraw(tp,1))
			and not tc:IsAttack(tc:GetBaseAttack()) then
			if Duel.SelectYesNo(tp,aux.Stringid(98346608,2)) then
				if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsControler(1-tp) and Duel.IsPlayerCanDraw(tp,1) then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end	
	end
end
