local m=53796076
local cm=_G["c"..m]
cm.name="破械之兽"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.lcon)
	e1:SetTarget(cm.ltg)
	e1:SetOperation(cm.lop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return (c:IsLocation(LOCATION_SZONE) and c:IsSetCard(0x130) and c:GetSequence()<5) or (c:IsLocation(LOCATION_MZONE) and c:IsLinkSetCard(0x130))
end
function cm.lcon(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkCondition(cm.mfilter,1,1)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.ltg(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkTarget(cm.mfilter,1,1)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e):Filter(Card.IsDestructable,nil,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp):Filter(Card.IsDestructable,nil,e)
	local mg3=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_SZONE,0,nil):Filter(Card.IsDestructable,nil,e)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function cm.lop(e,tp,eg,ep,ev,re,r,rp,c,...)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	aux.LExtraMaterialCount(g,c,tp)
	Duel.Destroy(g,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1130) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SetOperationInfo(0,HINTMSG_DESTROY,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
