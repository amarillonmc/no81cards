--救世主式·狂风领主
local m=40009166
local cm=_G["c"..m]
cm.named_with_BLASTER=1
function cm.BLASTERBlade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTERBlade
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)   
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e2:SetValue(1000)
	c:RegisterEffect(e2) 
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(cm.atkcon2)
	e3:SetTarget(cm.atkktg)
	e3:SetCost(cm.spcost)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.BLASTER(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTER
end
function cm.tgfilter(c)
	return cm.BLASTERBlade(c) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(cm.activate)
		local rg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		e:SetLabel(1)
		Duel.SendtoGrave(rg,REASON_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetLabel(0)
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function cm.spfilter(c,e,tp)
	return cm.BLASTER(c) and c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,tp,SUMMON_TYPE_LINK,40009156)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.atkktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.atktg)
	e1:SetValue(2000)
	Duel.RegisterEffect(e1,tp)
	--Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.discon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function cm.atktg(e,c)
	return c:GetSequence()>=5
end

