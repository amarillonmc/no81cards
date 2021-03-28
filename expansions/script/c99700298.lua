--圣界龙魂构造之书
function c99700298.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700298,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c99700298.amcost)
	e1:SetTarget(c99700298.target)
	e1:SetOperation(c99700298.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700298,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
	e2:SetHintTiming(TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,99700298)
	e2:SetCost(c99700298.amcost)
	e2:SetTarget(c99700298.mattg)
	e2:SetOperation(c99700298.matop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700298,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,99700299)
	e3:SetCost(c99700298.amcost)
	e3:SetCondition(c99700298.rmcon)
	e3:SetTarget(c99700298.rmtg)
	e3:SetOperation(c99700298.rmop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99700298,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9970000)
	e4:SetCost(c99700298.amcost)
	e4:SetTarget(c99700298.thtg)
	e4:SetOperation(c99700298.thop)
	c:RegisterEffect(e4)
end
function c99700298.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,99700298,0xfd04,0x21,1500,1000,4,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99700298.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99700298,0xfd04,0x21,1500,1000,4,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function c99700298.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700298,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700298.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700298.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c99700298.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd02) or c:IsSetCard(0xfd03) or c:IsSetCard(0xfd04))
end
function c99700298.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd01) or re:GetHandler():IsSetCard(0xfd02) or re:GetHandler():IsSetCard(0xfd03) or re:GetHandler():IsSetCard(0xfd04))
end
function c99700298.matfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd04)) and c:IsType(TYPE_XYZ)
end
function c99700298.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99700298.matfilter(chkc) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(c99700298.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99700298.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99700298.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c99700298.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return (c:GetOriginalRace()==RACE_SPELLCASTER or c:GetOriginalRace()==RACE_DRAGON) 
	and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99700298.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99700298.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99700298.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c99700298.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c99700298.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c99700298.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c99700298.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd04) ) and c:IsAbleToHand()
end
function c99700298.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700298.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99700298.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99700298.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end