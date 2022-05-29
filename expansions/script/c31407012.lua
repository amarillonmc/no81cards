local m=31407012
local cm=_G["c"..m]
cm.name="隐喻使 亚舍斯"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetCondition(cm.lvcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetLabel(5)
	e1:SetCondition(cm.sycon)
	e1:SetOperation(cm.syop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetLabel(7)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetLabel(9)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetLabel(11)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.tgcon)
	e5:SetTarget(cm.tgtg)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(cm.assisop)
	c:RegisterEffect(e7)
end
function cm.lvcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.stfilter1(c)
	return c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.stfilter2(c)
	return not c:IsAttribute(ATTRIBUTE_DARK) 
end
function cm.stfilter(c,tc) 
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove() and c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(tc,c,LOCATION_GRAVE)
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	if g:FilterCount(cm.stfilter,nil,tc)~=#g then return false end
	local g1=g:Filter(cm.stfilter1,nil)
	local g2=g:Filter(cm.stfilter2,nil)
	local count=g:GetCount()
	return g1:GetCount()==1 and g2:GetCount()==count-1 and g:GetSum(Card.GetLevel)==lv and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local lv=e:GetLabel()
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(Card.IsSynchroType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,lv,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,lv,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(Card.IsSynchroType,tp,LOCATION_GRAVE,0,nil,TYPE_TUNER)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,lv,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,lv,nil))
	end
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
	e:GetLabelObject():SetValue(lv)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.assisop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end