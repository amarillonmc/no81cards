local m=31400093
local cm=_G["c"..m]
cm.name="星尘幻想"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function cm.filter_tuner(c)
	return c:IsSetCard(0xa3) and c:IsType(TYPE_TUNER)
end
function cm.filter_nontuner(c)
	return not c:IsType(TYPE_TUNER)
end
function cm.remove_filter(c)
	return c:GetLevel()>0 and c:IsAbleToRemove()
end
function cm.group_filter(g)
	local num_t=g:FilterCount(cm.filter_tuner,nil)
	local num_nt=g:FilterCount(cm.filter_nontuner,nil)
	local lv=g:GetSum(Card.GetLevel)
	return num_t==1 and (num_nt==1 or num_nt==2) and num_t+num_nt==#g and lv>=8 and Duel.IsPlayerCanSpecialSummonMonster(tp,31400139,0xa3,TYPE_TOKEN+TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO,2500,2000,lv,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(cm.remove_filter,tp,LOCATION_GRAVE,0,nil):CheckSubGroup(cm.group_filter,2,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(cm.remove_filter,tp,LOCATION_GRAVE,0,nil):SelectSubGroup(tp,cm.group_filter,false,2)
	if g then
		local lv=g:GetSum(Card.GetLevel)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local token=Duel.CreateToken(tp,31400139)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		token:RegisterEffect(e1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end