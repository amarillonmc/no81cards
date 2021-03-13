--疾如风·赛科忒
local m=111014
local cm=_G["c"..m]
function cm.initial_effect(c)
   --SynchroSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
end
function cm.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_BEASTWARRIOR) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsLevel(lv+1) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.refilter(c,e,tp,lv)
	local lvl=c:GetLevel()
	local sum=lvl+lv
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsAttack(1950) and c:IsRace(RACE_BEASTWARRIOR) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sum)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_GRAVE,0,1,c,e,tp,lv)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local reg=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp,lv)
	reg:AddCard(c)
	Duel.Remove(reg,POS_FACEUP,REASON_COST)
	local g=Duel:GetOperatedGroup()
	local sum=Group.GetSum(g,Card.GetLevel)
	e:SetLabel(sum)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chk==0 then 
			return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end