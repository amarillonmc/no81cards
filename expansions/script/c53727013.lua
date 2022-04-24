local m=53727013
local cm=_G["c"..m]
cm.name="电脑深域N 天道主机"
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.lcon)
	e0:SetTarget(cm.ltg)
	e0:SetOperation(cm.lop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(EFFECT_MATERIAL_CHECK)
	ex:SetValue(cm.valcheck)
	c:RegisterEffect(ex)
	e1:SetLabelObject(ex)
	e2:SetLabelObject(ex)
end
function cm.valcheck(e,c)
	e:SetLabel(0)
	if c:GetMaterial():IsExists(Card.IsLinkType,1,nil,TYPE_FUSION) then e:SetLabel(1) end
end
function cm.lcon(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkCondition(nil,2,4,nil)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.ltg(...)
	local f=aux.GetLinkMaterials
	aux.GetLinkMaterials=cm.GetLinkMaterials
	local res=Auxiliary.LinkTarget(nil,2,4,nil)(...)
	aux.GetLinkMaterials=f
	return res
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	local mg3=Duel.GetMatchingGroup(function(c)return aux.IsCodeListed(c,53727003) and c:IsFacedown()end,tp,LOCATION_ONFIELD,0,nil)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	if mg3:GetCount()>0 then mg:Merge(mg3) end
	return mg
end
function cm.lop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	 local g=e:GetLabelObject()
	 c:SetMaterial(g)
	 aux.LExtraMaterialCount(g,c,tp)
	 local cg=g:Filter(Card.IsFacedown,nil)
	 if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	 Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	 g:DeleteGroup()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==0 and not e:GetHandler():IsCode(53727003)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1 or e:GetHandler():IsCode(53727003)
end
function cm.tgfilter(c)
	return c:IsCode(53727008) and c:IsAbleToGrave()
end
function cm.tdfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then s=Duel.SelectOption(tp,aux.Stringid(m,0)) end
	if not b1 and b2 then s=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	if b1 and b2 then s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	elseif e:GetLabel()==1 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	end
end
