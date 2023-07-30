--魔导列车
local m=60002250
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--spsm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e1:SetLabelObject(ng)
	e3:SetLabelObject(ng)
	e2:SetLabelObject(ng)
end
function cm.ffilter(c)
	return c:IsRace(RACE_MACHINE)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsLevelAbove(5)
end
function cm.dfilter(c,tp)
	return not c:IsCode(m) and not c:IsCode(60002248)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(eg,REASON_EFFECT)~=0 then
		eg:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		e:GetLabelObject():AddCard(eg)
	end
	local g=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.spfilter(c,e,tp)
	return c:GetFlagEffect(m)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject():Filter(cm.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=e:GetLabelObject()
	local rgr=nil
	local num=math.min(rg:GetCount(),5-ft1)
	if num>=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		rgr=rg:Select(tp,num,num,nil)
		Duel.SpecialSummon(rgr,0,tp,tp,false,false,POS_FACEUP)
	end
end





