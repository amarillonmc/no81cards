--外道魔之魔主
local m=91040046
local cm=c91040046
function c91040046.initial_effect(c)
aux.AddCodeList(c,35405755)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(aux.IsCodeListed(c,35405755)),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(cm.spcon0)
	e1:SetTarget(cm.sptg0)
	e1:SetOperation(cm.spop0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m*2)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.spcon1)
	e4:SetTarget(cm.sptg1)
	e4:SetOperation(cm.spop1)
	c:RegisterEffect(e4)
end
function cm.fselect(g,tp)
	return Duel.GetMZoneCount(1-tp,g,tp)>0 
end
function cm.fit0(c)
	return  c:IsReleasable() and aux.IsCodeListed(c,35405755)
end
function cm.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(cm.fit0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,REASON_SPSUMMON)
	return rg:CheckSubGroup(cm.fselect,2,2,tp)
end
function cm.sptg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(cm.fit0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,cm.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function cm.filter(c,e,ts)
	return aux.IsCodeListed(c,35405755) and c:IsCanBeSpecialSummoned(e,0,ts,false,false) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ts=e:GetHandler():GetOwner()
	   if chk==0 then return  Duel.IsExistingMatchingCard(cm.filter,ts,LOCATION_GRAVE,0,1,nil,e,ts) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,ts,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ts=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(ts,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,ts,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(ts,cm.filter,ts,LOCATION_GRAVE,0,1,1,nil,e,ts)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,ts,ts,false,false,POS_FACEUP)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(35405755)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
