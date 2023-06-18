--天璀司·泪巢
local m=82209094
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,aux.TRUE,aux.NonTuner(aux.FilterBoolFunction(Card.IsSetCard,0x9298)),1)  
	c:EnableReviveLimit()  
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.synlimit)  
	c:RegisterEffect(e0)  
	--set  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--to hand 2 
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))  
	e5:SetCategory(CATEGORY_TOHAND)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_BATTLE_START)  
	e5:SetCondition(cm.thcon2)  
	e5:SetTarget(cm.thtg2)  
	e5:SetOperation(cm.thop2)  
	c:RegisterEffect(e5)  
end
cm.toss_coin=true 

--set
function cm.spfilter(c,e,tp)  
	return c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local coin
	if Duel.IsPlayerAffectedByEffect(tp,82209091) and Duel.GetFlagEffect(tp,82219091)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,82209091)
		coin=1
		Duel.RegisterFlagEffect(tp,82219091,RESET_PHASE+PHASE_END,0,1)
	else
		coin=Duel.TossCoin(tp,1)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and coin==1 then
			local e1=Effect.CreateEffect(c)  
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			g:GetFirst():RegisterEffect(e1)  
		end  
	end
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,1)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)   
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_GRAVE) and c:IsLevelBelow(5)
end  

--to hand 2
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToHand() end 
	local g=Group.FromCards(bc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)  
	local bc=e:GetHandler():GetBattleTarget()  
	if bc:IsRelateToBattle() then  
		Duel.SendtoHand(bc,tp,REASON_EFFECT)
	end  
end  