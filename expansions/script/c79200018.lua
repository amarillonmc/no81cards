--字界眼伟岸龙
local m=79200018
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Xyz Summon
	aux.AddXyzProcedure(c,nil,7,5)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
--special summon rule
	local e2=Effect.CreateEffect(c)
	  e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetCondition(cm.mtcon)
	e3:SetTarget(cm.mttg)
	e3:SetOperation(cm.mtop)
	c:RegisterEffect(e3)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_REMOVE)
 --special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)

end
function cm.cfilter2(c,tp,tc)
	return c:IsSetCard(0x684) and  Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_MZONE,0,1,nil,tp,c,tc) 
end
function cm.cfilter3(c,tp,mc,tc)
	local g=Group.CreateGroup()
	g:AddCard(mc)
	g:AddCard(c)
	return c:IsSetCard(0x681) and c:IsType(TYPE_TUNER) 
end
function cm.cfilter4(c,tp,tc)
	 return ((c:IsSetCard(0x684) and  (Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_MZONE,0,1,nil,tp,c,tc) )) or (c:IsSetCard(0x681) and c:IsType(TYPE_TUNER)))
end
function cm.sprcon(e,c)
	if c==nil then return true end
	 local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.cfilter5(c)
	 return c:IsSetCard(0x681) and c:IsType(TYPE_TUNER) 
end
function cm.check(g,tp,tc)
	return g:IsExists(cm.cfilter5,1,nil) and g:IsExists(cm.cfilter2,1,nil,tp,tc) and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.cfilter4,tp,LOCATION_MZONE,0,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,cm.check,false,2,2,tp,c)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_COST)
end

function cm.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.remfilter,1,nil)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToChain() and c:IsType(TYPE_XYZ)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if #mg>0 then
		Duel.Overlay(c,mg)
	end
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(79200001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end