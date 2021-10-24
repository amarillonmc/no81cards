--幻梦灵兽 艾路雷朵
function c33200103.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200103)
	e1:SetCondition(c33200103.spcon1)
	e1:SetTarget(c33200103.sptg)
	e1:SetOperation(c33200103.spop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c33200103.spcon2)
	c:RegisterEffect(e3) 
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200103,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c33200103.destg)
	e2:SetOperation(c33200103.desop)
	c:RegisterEffect(e2)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(c33200103.damcon)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)	
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,33200103)
	e5:SetCost(c33200103.thcost)
	e5:SetTarget(c33200103.thtg)
	e5:SetOperation(c33200103.thop)
	c:RegisterEffect(e5)
end

--e1
function c33200103.spfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x324) and not c:IsCode(33200103) and c:IsAbleToHand()
		and (ft>0 or c:GetSequence()<5) and not c:IsType(TYPE_XYZ)
end
function c33200103.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200103.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsPlayerAffectedByEffect(tp,33200100)
end
function c33200103.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200103.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsPlayerAffectedByEffect(tp,33200100) 
end
function c33200103.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33200103.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200103.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c33200103.spfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c33200103.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc and tc:IsRelateToEffect(e) and ft>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end

--e2
function c33200103.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33200103.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--e4
function c33200103.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end

--e5
function c33200103.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x324) and c:IsAbleToGraveAsCost() and not c:IsCode(33200103)
end
function c33200103.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200103.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c33200103.thfilter,1,1,REASON_COST)
end
function c33200103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33200103.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end