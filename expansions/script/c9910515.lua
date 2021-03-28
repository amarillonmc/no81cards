--桃绯武士 槇数马
function c9910515.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910515)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910515.spcon)
	e1:SetTarget(c9910515.sptg)
	e1:SetOperation(c9910515.spop)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,9910516)
	e3:SetTarget(c9910515.atktg)
	e3:SetOperation(c9910515.atkop)
	c:RegisterEffect(e3)
end
function c9910515.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c9910515.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if c:IsFaceup() then g:AddCard(c) end
	if chk==0 then return g:GetCount()>0 end
	e:SetLabel(c:GetAttack()-c:GetBaseAttack())
end
function c9910515.spfilter(c,e,tp,sum)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0xa950) and c:IsAttackBelow(sum)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c9910515.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	if label<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) then g:AddCard(c) end
	local sum=0
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local preatk=sc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-label)
			sc:RegisterEffect(e1)
			if sc:GetAttack()<preatk then sum=sum+preatk-sc:GetAttack() end
			sc=g:GetNext()
		end
	end
	if sum~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910515.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,sum)
		and Duel.SelectYesNo(tp,aux.Stringid(9910515,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910515.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,sum)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c9910515.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9910515.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
