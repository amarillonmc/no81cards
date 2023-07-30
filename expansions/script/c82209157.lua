--幻蝶刺客 蛱蝶
local m=82209157
local cm=c82209157
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)  
	--negate  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DISABLE)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetCode(EVENT_CHAINING)  
	e4:SetCountLimit(1,m+10000)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCondition(cm.discon)  
	e4:SetTarget(cm.distg)  
	e4:SetOperation(cm.disop)  
	c:RegisterEffect(e4) 
end
function cm.counterfilter(c)  
	return c:IsType(TYPE_XYZ) or (not c:GetSummonLocation()==LOCATION_EXTRA)
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return c:IsLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_XYZ)) 
end  
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x6a) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)  
	end  
end  
function cm.disfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)  
	return bit.band(loc,LOCATION_ONFIELD)~=0 
		and rp==1-tp and Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanChangePosition() end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	local rc=re:GetHandler()  
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then 
		Duel.NegateEffect(ev)  
	end  
end  