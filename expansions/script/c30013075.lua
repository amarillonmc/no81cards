--深土领君 绿之主
local m=30013075
local cm=_G["c"..m]
if not exsumproc then dofile("expansions/script/c30088800.lua") end
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	espoc.AddSynchroMixProcedure(c,cm.syf,nil,nil,aux.NonTuner(Card.IsSynchroType,TYPE_FLIP),1,99)
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_POSITION)
	e01:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e01:SetProperty(EFFECT_FLAG_DELAY)
	e01:SetCountLimit(1,m)
	e01:SetTarget(cm.sptg)
	e01:SetOperation(cm.spop)
	c:RegisterEffect(e01)
	--Effect 2 
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--e1:SetCode(EVENT_FLIP)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e1:SetOperation(cm.flipop)
	--c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetTargetRange(LOCATION_MZONE,0)
	--e2:SetCondition(cm.imecon)
	--e2:SetTarget(cm.imetg)
	--e2:SetValue(1500)
	--c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--e3:SetCode(EFFECT_UPDATE_DEFENSE)
	--c:RegisterEffect(e3)
	--local e11=Effect.CreateEffect(c)
	--e11:SetType(EFFECT_TYPE_FIELD)
	--e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e11:SetRange(LOCATION_MZONE)
	--e11:SetTargetRange(LOCATION_ONFIELD,0)
	--e11:SetCondition(cm.imecon)
	--e11:SetTarget(cm.imetg)
	--e11:SetValue(1)
	--c:RegisterEffect(e11)
	--local e12=e11:Clone()
	--e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e12)
	--Effect 3 
	--local e32=Effect.CreateEffect(c)
	--e32:SetCategory(CATEGORY_TOHAND)
	--e32:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	--e32:SetRange(LOCATION_GRAVE)
	--e32:SetCode(EVENT_PHASE+PHASE_END)
	--e32:SetCountLimit(1,m+100)
	--e32:SetCondition(cm.specon1)
	--e32:SetCost(cm.specost)
	--e32:SetTarget(cm.spetg)
	--e32:SetOperation(cm.speop)
	--c:RegisterEffect(e32)
	--local e33=Effect.CreateEffect(c)
	--e33:SetCategory(CATEGORY_TOHAND)
	--e33:SetType(EFFECT_TYPE_QUICK_O)
	--e33:SetCode(EVENT_FREE_CHAIN)
	--e33:SetRange(LOCATION_GRAVE)
	--e33:SetCountLimit(1,m+100)
	--e33:SetCondition(cm.specon2)
	--e33:SetCost(cm.specost)
	--e33:SetTarget(cm.spetg)
	--e33:SetOperation(cm.speop)
	--c:RegisterEffect(e33)
end
--synchro summon
function cm.syf(c)
	return c:IsSynchroType(TYPE_FLIP) 
end
--Effect 1
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEDOWN_DEFENSE)
end
function cm.hf(c)
	local b1=c:IsType(TYPE_FLIP)
	local b2=c:IsSetCard(0x92c)
	return (b1 or b2) and c:IsDiscardable(REASON_EFFECT)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if ft==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return false end
	local tc=sg:GetFirst()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEDOWN_DEFENSE)==0 then return false end
	tc:SetMaterial(nil)
	tc:CompleteProcedure()
	Duel.ConfirmCards(1-tp,tc)
	local hg=Duel.GetMatchingGroup(cm.hf,tp,LOCATION_HAND,0,nil,e,tp)
	if #hg>0 and tc:IsPosition(POS_FACEDOWN_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,cm.hf,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return false end
		local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		Duel.ChangePosition(tc,pos)
	end
end
--Effect 2
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2)) 
end
function cm.imecon(e)
	local ec=e:GetHandler()
	return ec:GetFlagEffect(m)>0
end
function cm.imetg(e,c)
	return c:IsSetCard(0x92c) or c:IsType(TYPE_FLIP) 
end
--Effect 3 
--Effect 3 
function cm.specon1(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020) 
end
function cm.specon2(e)
	local c=e:GetHandler()
	local tsp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020) 
end
function cm.specost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spe(c,e,tp)
	return  c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function cm.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spe,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.speop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if Duel.IsPlayerAffectedByEffect(tp,30013020) then
		ct=2 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spe),tp,LOCATION_GRAVE,0,1,ct,e:GetHandler(),e,tp)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end  