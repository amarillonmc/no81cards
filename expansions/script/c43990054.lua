--N公司 大锤 默尔索
local m=43990054
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990054,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c43990054.ttcon)
	e1:SetOperation(c43990054.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,43990054)
	e2:SetCost(c43990054.thcost)
	e2:SetTarget(c43990054.thtg)
	e2:SetOperation(c43990054.thop)
	c:RegisterEffect(e2)
	--CATEGORY_DISABLE
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,43991054)
	e3:SetTarget(c43990054.dttg)
	e3:SetOperation(c43990054.dtop)
	c:RegisterEffect(e3)
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,43992054)
	e4:SetCondition(c43990054.spcon)
	e4:SetTarget(c43990054.sptg)
	e4:SetOperation(c43990054.spop)
	c:RegisterEffect(e4)
	
end
function c43990054.spcon(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_MACHINE>0 and rp==1-tp
end
function c43990054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c43990054.ctfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990054.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c43990054.ctfilter,tp,0,LOCATION_MZONE,nil)
	return minc<=2 and Duel.CheckTribute(c,2,2,mg,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c43990054.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c43990054.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.SelectTribute(tp,c,2,2,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c43990054.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c43990054.thfilter(c)
	return c:IsSetCard(0x3510) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c43990054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990054.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c43990054.dtfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup() and aux.NegateMonsterFilter(c)
end
function c43990054.dttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c43990054.dtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43990054.dtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c43990054.dtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c43990054.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end



