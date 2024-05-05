--银河列车·青雀
function c78303060.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x746),nil,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78303060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,78303060)
	e1:SetCondition(c78303060.spcon)
	e1:SetTarget(c78303060.sptg)
	e1:SetOperation(c78303060.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,88303060)
	e2:SetCondition(c78303060.pencon)
	e2:SetTarget(c78303060.pentg)
	e2:SetOperation(c78303060.penop)
	c:RegisterEffect(e2)
c78303060.toss_dice=true
end
function c78303060.cfilter(c)
	return c:IsSetCard(0x746) and c:IsFaceup()
end
function c78303060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c78303060.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c78303060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c78303060.lvfilter(c)
	return c:IsSetCard(0x746) and c:IsFaceup() and c:GetLevel()>0 and not c:IsLevel(4)
end
function c78303060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0  then
		local dc=Duel.TossDice(tp,1)
		if dc<=6 and dc>=3 and Duel.IsExistingMatchingCard(c78303060.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(78303060,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(78303060,2))
			local tc=Duel.SelectMatchingCard(tp,c78303060.lvfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(4)
			tc:RegisterEffect(e1)
		end
	end
end
function c78303060.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and r==REASON_SYNCHRO
end
function c78303060.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c78303060.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
