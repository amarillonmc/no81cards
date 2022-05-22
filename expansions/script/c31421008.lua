local m=31421008
local cm=_G["c"..m]
cm.name="弹幕少女『无双风神』"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,cm.filter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.otcon)
	e2:SetOperation(cm.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
end
cm.list={31421001,31421002,31421003,31421004,31421005,31421006,31421007,31421008}
function cm.filter(c)
	return c:IsCode(table.unpack(cm.list))
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function cm.otfilter(c,tc,exg)
	local con1=c:IsAttribute(ATTRIBUTE_WIND)
	local tbg=Group.__add(exg,c)
	local con2=Duel.CheckTribute(tc,2,2,tbg)
	return con1 and con2
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local p=c:GetControler()
	local exg=Duel.GetMatchingGroup(aux.TRUE,p,0,LOCATION_ONFIELD,nil)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e:SetRange(LOCATION_HAND)
	e:SetTargetRange(0,LOCATION_ONFIELD)
	e:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	c:RegisterEffect(e)
	local mg=Duel.GetMatchingGroup(cm.otfilter,p,LOCATION_MZONE,0,nil,c,exg)
	local res=c:IsLevelAbove(7) and minc<=2 and mg:GetCount()>0
	e:Reset()
	return res
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e:SetRange(LOCATION_HAND)
	e:SetTargetRange(0,LOCATION_ONFIELD)
	e:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	c:RegisterEffect(e)
	local exg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,0,nil,c,exg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTribute(tp,c,1,1,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectTribute(tp,c,1,1,exg)
	sg:Merge(g)
	e:Reset()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end