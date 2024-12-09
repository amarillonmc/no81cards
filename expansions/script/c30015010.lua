local m=30015010
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,11,6,3)
	--Effect 0
	local e1=ors.atkordef(c,150,2500)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(ors.adsumcon)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	--Effect 3 
	local e11=ors.monsterleup(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015010.isoveruins=true
--all
--Effect 2 
function cm.rmcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.kf(c,tp)
	local b1=c:IsType(TYPE_SPELL+TYPE_TRAP)
	local b2=not c:IsAbleToRemove(tp,POS_FACEDOWN)
	return b1 and b2
end
function cm.rmf(c,tp)
	local b1=c:IsType(TYPE_SPELL+TYPE_TRAP)
	local b2=c:IsAbleToRemove(tp,POS_FACEDOWN)
	return b1 and b2
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local rg=g:Filter(cm.rmf,nil,tp)
	if chk==0 then
		return #rg>0 and g:FilterCount(cm.kf,nil,tp)==0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(re,rp,tp)
	return tp==rp or not re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local rg=g:Filter(cm.rmf,nil,tp)
	if #rg==0 then return false end
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	local hg=Duel.GetMatchingGroup(cm.rmf,tp,0,LOCATION_HAND,nil,tp)
	if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rmg=hg:Select(tp,1,2,nil)
		Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end