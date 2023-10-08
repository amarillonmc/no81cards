--黄 金 龙  瑞 卡 扎
local m=22348331
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348331)
	e1:SetCost(c22348331.spcost)
	e1:SetTarget(c22348331.sptg)
	e1:SetOperation(c22348331.spop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348331.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,22349331)
	e4:SetCost(c22348331.descost)
	e4:SetTarget(c22348331.destg)
	e4:SetOperation(c22348331.desop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(22348331,ACTIVITY_SPSUMMON,c22348331.counterfilter)
	
end
function c22348331.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c22348331.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
function c22348331.desfilter(c,att)
	return c:IsFaceup() and c:IsAttackBelow(att)
end
function c22348331.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local att=c:GetAttack()
	local sg=Duel.GetMatchingGroup(c22348331.desfilter,tp,0,LOCATION_MZONE,nil,att)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		local tg=Duel.GetOperatedGroup()
		local tgc=tg:GetCount()
		Duel.Draw(tp,tgc,REASON_EFFECT)
	elseif ct then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

function c22348331.counterfilter(c)
	return not c:IsType(TYPE_LINK)
end
function c22348331.costfilter(c,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 and c:IsType(TYPE_EFFECT) and c:IsLevelAbove(5)
end
function c22348331.chk(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c22348331.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348331.costfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return g:CheckSubGroup(c22348331.chk,2,2) and Duel.GetCustomActivityCount(22348331,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c22348331.chk,false,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22348331.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c22348331.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_LINK)
end
function c22348331.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c22348331.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function c22348331.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*400
end



