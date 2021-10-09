--魔法骑士wizard·流水魔龙
function c9980842.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	 c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980842,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9980842)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9980842.spcon)
	e1:SetTarget(c9980842.sptg)
	e1:SetOperation(c9980842.spop)
	c:RegisterEffect(e1)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9980842.ptg)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980842,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99808420)
	e1:SetCondition(c9980842.thcon)
	e1:SetTarget(c9980842.thtg)
	e1:SetOperation(c9980842.thop)
	c:RegisterEffect(e1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--control
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9980842,2))
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c9980842.ctcost)
	e7:SetTarget(c9980842.cttg)
	e7:SetOperation(c9980842.ctop)
	c:RegisterEffect(e7)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980842.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980842.ptg(e,c)
	return c:IsSetCard(0x5bc2)
end
function c9980842.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980842,3))
end
function c9980842.spcon(e,tp,eg,ep,ev,re,r,rp)
	 local rc=re:GetHandler()
	return (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x5bc2)) or (ep==1-tp and not rc:IsStatus(STATUS_BATTLE_DESTROYED))
end
function c9980842.spfilter(c,e,tp)
	return c:IsSetCard(0x5bc2) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and not c:IsCode(9980842) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980842.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9980842.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9980842.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
		if Duel.GetLocationCountFromEx(tp)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980842.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c9980842.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c9980842.thfilter(c)
	return c:IsSetCard(0x5bc2) and c:IsAbleToHand()
end
function c9980842.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980842.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980842.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980842.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980842,4))
	end
end
function c9980842.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9980842.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c9980842.costfilter(c,tp)
	return Duel.IsExistingTarget(c9980842.filter,tp,0,LOCATION_MZONE,1,c)
end
function c9980842.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9980842.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c9980842.costfilter,1,c,tp)
		else
			return Duel.IsExistingTarget(c9980842.filter,tp,0,LOCATION_MZONE,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c9980842.costfilter,1,1,c,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9980842.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9980842.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,tp,PHASE_END,1)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980842,4))
	end
end
