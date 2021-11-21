--G-神智的泛衍
local m=16107110
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local nova=0x1cc ----nova counter
function cm.initial_effect(c)
	c:EnableCounterPermit(nova)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e0)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		Sr_GODback={}
		Sr_GODback[1]=0 
		local res1=Effect.CreateEffect(c)
		res1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		res1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		res1:SetOperation(cm.reset)
		Duel.RegisterEffect(res1,0)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	Sr_GODback={}
	Sr_GODback[1]=0
end
function GetOr(tab)
	local num=0
	for i,v in ipairs(tab) do
		num=num|v
	end
	return num
end
function cm.actcon(e,tp)
	return Duel.GetMatchingGroupCount(cm.gfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>0
end
function cm.gfilter(c)
	return c:IsRankAbove(10) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
----
function cm.splimit(e,c)
	return not (c:IsSetCard(0x5ccc) or c:IsLevelAbove(10) or c:IsRankAbove(10))
end
----
function cm.sumfilter(c,e,tp,att)
	return (c:IsSetCard(0x5ccc) or (c:IsRace(RACE_MACHINE) and c:IsLevel(10))) and not c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsAttribute(GetOr(Sr_GODback))
end
function cm.spmfilter(c,e,tp)
	local att=c:GetAttribute()
	return c:GetSummonLocation()~=LOCATION_DECK and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_DECK,0,1,nil,e,tp,att) and c:IsSetCard(0x5ccc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not eg then return false end
	if eg:GetCount()>1 then return false end
	if not eg:IsExists(cm.spmfilter,1,nil,e,tp) then return false end
	local tc=eg:GetFirst()
	local att=tc:GetAttribute()
	e:SetLabel(att)
	if chkc then return chkc==tc end
	if chk==0 then return tc:IsFaceup() and tc:IsOnField() and tc:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=eg:GetFirst()
	if sc:IsFaceup() and sc:IsRelateToEffect(e) then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	local tc=g:GetFirst()
	Sr_GODback[#Sr_GODback+1]=tc:GetOriginalAttribute()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end