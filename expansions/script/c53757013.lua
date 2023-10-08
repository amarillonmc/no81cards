if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53757013
local cm=_G["c"..m]
cm.name="次元秽界魔导 驭者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x2,LOCATION_EXTRA)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.ptg)
	e4:SetOperation(cm.pop)
	c:RegisterEffect(e4)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.cfilter(c,tp,b1)
	return c:IsLevel(3) and c:IsRace(RACE_DRAGON) and (c:IsControler(tp) or c:IsFaceup()) and (b1 or Duel.GetMZoneCount(tp,c)>0)
end
function cm.thfilter(c)
	return c:IsCode(m-1) and c:IsAbleToHand()
end
function cm.filter(c)
	return c:GetType()&0x20002==0x20002 and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local res=false
	for tc in aux.Next(g) do if aux.IsCodeListed(c,tc:GetCode()) then res=true end end
	return res and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) and Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp,b1) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp,b1)
	Duel.Release(g,REASON_COST)
	local b3=b2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local res=opval[op]
	e:SetLabel(res)
	if res==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif res==2 then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
function cm.tffilter(c,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_FIELD~=0 and not c:IsLocation(LOCATION_FZONE) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if tc:IsLocation(LOCATION_SZONE) then Duel.MoveSequence(tc,5) else Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
end
