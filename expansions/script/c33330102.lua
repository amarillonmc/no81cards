--造神计划2 安提凯希拉装置
local m=33330102
local cm=_G["c"..m]
function c33330102.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--to grave and SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(cm.cost)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.sgtg)
	e5:SetOperation(cm.sgop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.table={}
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm.table={}
end
function cm.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and not c:IsLinkRace(RACE_MACHINE)
end
function cm.thfilter(c,e)
	local se=e:GetHandler():GetSequence()
	if  se ==5 then
		se=1
	elseif se==6 then
		se=3
	end
	local seq=c:GetSequence()
	if  seq ==5 then
		seq=1
	elseif seq==6 then
		seq=3
	end
	return math.abs(se-seq)==1--g:IsContains(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	local atj=Duel.SendtoGrave(g,REASON_EFFECT)
	if atj~=0 then
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atj*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

function cm.costfil(c)
	for i,v in ipairs(cm.table) do
		if v==c:GetCode() then return false end
	end
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
	--return  c:IsAbleToGrave()--c:IsAbleToDeckAsCost()--c:IsPublic() and
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.costfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function cm.filter(c,e,tp,tc)
	return c==tc--c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.sgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		table.insert(cm.table,tc:GetCode())
	end
end