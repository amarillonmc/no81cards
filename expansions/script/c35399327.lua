--疾 行 机 人 变 形 钢 笔
local m=35399327
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--sp 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399327,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,35399327)
	e1:SetCondition(c35399327.spcon)
	e1:SetTarget(c35399327.sptg)
	e1:SetOperation(c35399327.spop)
	c:RegisterEffect(e1)  
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399327,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,35398327)
	e2:SetCondition(c35399327.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c35399327.thtg)
	e2:SetOperation(c35399327.thop)
	c:RegisterEffect(e2)
	
end
function c35399327.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c35399327.spconf(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsPreviousControler(tp)
end
function c35399327.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spconf,1,nil,tp) and not Duel.IsExistingMatchingCard(c35399327.cfilter,tp,LOCATION_MZONE,0,1,nil) and not eg:IsContains(e:GetHandler())
end
function c35399327.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399327.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsLocation(LOCATION_MZONE) then
		local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
		Duel.BreakEffect()
		lv=Duel.AnnounceLevel(tp,1,6,lv)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c35399327.thfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end
function c35399327.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c35399327.thfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c35399327.thfilter1(c)
	return c:IsAbleToHand()
end
function c35399327.thfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c35399327.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c35399327.thfilter1,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c35399327.thfilter2,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
		g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_ONFIELD)
end
function c35399327.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,c35399327.thfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c35399327.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		g1:Merge(g2)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
