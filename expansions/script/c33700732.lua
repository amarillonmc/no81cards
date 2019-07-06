--铁虹的荣誉
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700732
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsneov.LPChangeFun(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return rsneov.LPTbl[tp+2]>=2000 end)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47435107,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp) return rsneov.LPTbl[tp]>0 end)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)  
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x44e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttackBelow(rsneov.LPTbl[tp])
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
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.activate(e)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_LPCOST_REPLACE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(cm.lrcon)
	e1:SetOperation(cm.lrop)
	Duel.RegisterEffect(e1,tp)
end
function cm.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	if not re or not re:IsHasType(0x7e0) then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x44e) and rc:IsType(TYPE_MONSTER)
end
function cm.lrop(e,tp,eg,ep,ev,re,r,rp)
	return 
end
