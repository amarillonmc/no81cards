--哎呀，已经变成井的牺牲品了吗
local m=64800000
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
if not cm.global_check then
		cm.global_check=true
		playerpaylpcostint=0
		local res1=Effect.CreateEffect(c)
		res1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		res1:SetCode(RESET_PHASE+PHASE_END)
		res1:SetOperation(cm.reset)
		Duel.RegisterEffect(res1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	playerpaylpcostint=playerpaylpcostint+ev
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	playerpaylpcostint=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return playerpaylpcostint>=75000 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function cm.spfilter(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
 Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
if not  cm.spcon(e,tp,eg,ep,ev,re,r,rp) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end