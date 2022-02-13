local m=188878
local cm=_G["c"..m]
cm.name="星魅的斩棘之刃-休特"
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e)return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4 end)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e)return e:GetHandler():GetSequence()==1 or e:GetHandler():GetSequence()==2 or e:GetHandler():GetSequence()==3 end)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rsgf.GetAdjacentGroup(e:GetHandler()):IsExists(function(c)return c:IsFaceup() and c:IsSetCard(0xca2)end,1,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(188874) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.desfilter1(c)
	return Duel.IsExistingMatchingCard(aux.TRUE,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,cm.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end
function cm.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
end
