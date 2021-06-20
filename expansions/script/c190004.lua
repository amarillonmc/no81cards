local m=190004
local cm=_G["c"..m]
cm.name="任务玩家Brave LV2"
function cm.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,190004)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,190004)
	e4:SetCost(cm.sp2cost)
	e4:SetCondition(cm.sp2con)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,190004)
	e5:SetCost(cm.sp3cost)
	e5:SetCondition(cm.sp2con)
	e5:SetTarget(cm.sp2tg)
	e5:SetOperation(cm.sp2op)
	c:RegisterEffect(e5)
	--up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,191004)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
end
function cm.atkval(e,c)
	return c:GetLevel()*100
end
function cm.spfilter(c,lv,e,tp)
	return c:IsSetCard(0xca5) and c:GetLevel()<=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp) and Duel.GetTurnPlayer()==tp end
	e:SetLabel(lv)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=3
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp) end
	e:SetLabel(lv)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.banfilter(c)
	return c:IsSetCard(0xca5) and c:IsAbleToRemoveAsCost()
end
function cm.sp3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return e:GetHandler():GetEffectCount(190011)~=0 and Duel.IsExistingMatchingCard(cm.banfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0 end
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.banfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv,e,tp):GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv,e,tp):GetFirst()
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end

function cm.thfilter(c)
	return c:IsAttackAbove(1) and c:IsDefenseAbove(1) and c:IsLevelAbove(1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,e:GetHandler(),1,tp,LOCATION_MZONE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local lv=tc:GetLevel()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and atk>0 and def>0 and lv>0 then
		--atk up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def/2)
		e:GetHandler():RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetValue(lv)
		e:GetHandler():RegisterEffect(e3)
	end
end