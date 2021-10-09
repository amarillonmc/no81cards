--鬼形兽EX 骊驹早鬼
function c9981306.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	  --change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981306,1))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9981306)
	e1:SetTarget(c9981306.sctg)
	e1:SetOperation(c9981306.scop)
	c:RegisterEffect(e1)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9981306.discon)
	e3:SetOperation(c9981306.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c9981306.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.penlimit)
	c:RegisterEffect(e3)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981306,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981306.damcon)
	e1:SetTarget(c9981306.damtg)
	e1:SetOperation(c9981306.damop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981306,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetTarget(c9981306.eqtg)
	e2:SetOperation(c9981306.eqop)
	c:RegisterEffect(e2)
   --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981306,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9981306.spcon)
	e3:SetTarget(c9981306.sptg)
	e3:SetOperation(c9981306.spop)
	c:RegisterEffect(e3)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981306.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981306.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981306,0))
end
function c9981306.scfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3bd1)
		and c:GetLeftScale()~=pc:GetLeftScale()
end
function c9981306.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981306.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c9981306.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981306,1))
	local g=Duel.SelectMatchingCard(tp,c9981306.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981306,0))
end
function c9981306.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3bd1) and c:IsControler(tp)
end
function c9981306.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c9981306.cfilter(c,tp)
end
function c9981306.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(9981306,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c9981306.distg(e,c)
	return c:GetFlagEffect(9981306)~=0
end
function c9981306.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c9981306.damfilter(c)
	return (c:IsFusionSetCard(0x3bd1) or c:IsAttribute(ATTRIBUTE_DARK))and c:GetBaseAttack()>0 and c:IsAbleToGrave()
end
function c9981306.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981306.damfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9981306.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9981306.damfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Damage(1-tp,math.floor(g:GetFirst():GetBaseAttack()),REASON_EFFECT)
	end
end
function c9981306.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c9981306.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		tc:RegisterFlagEffect(9981306,RESET_EVENT+RESETS_STANDARD,0,0)
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c9981306.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981306,0))
end
function c9981306.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9981306.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9981306.spfilter(c,e,tp)
	return c:IsSetCard(0x3bd1) and not c:IsCode(9981306) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981306.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9981306.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9981306.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9981306.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9981306.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
