--苍之战士 银河宙蓝
local m=40006766
local cm=_G["c"..m]
cm.named_with_blaucavalier=1
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsCanOverlay()
end
function cm.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(1)
end
function cm.mnfilter(c,g)
	return g:IsExists(cm.mnfilter2,1,c,c)
end
function cm.mnfilter2(c,mc)
	return c:GetLevel()+mc:GetLevel()==11
end
function cm.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(cm.tgrfilter1,2,nil)
		and g:IsExists(cm.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp,c)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local matg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp,c)
	local og = Group.CreateGroup()
	for tc in aux.Next(matg) do
		og:Merge(tc:GetOverlayGroup())
	end
	if #og>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(c,matg)
end
function cm.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsLevelAbove(1)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(cm.rmfilter,1,nil) end
	local g=e:GetHandler():GetOverlayGroup():IsExists(cm.rmfilter,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=lg:FilterSelect(tp,cm.rmfilter,1,1,nil,e,tp)
	if #g==0 then return end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	local sc=g:GetFirst()
	if sc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) and c:IsFaceup() and sc:IsFaceup() and c:IsControler(tp)
		and c:IsCanBeXyzMaterial(sc) and sc:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
