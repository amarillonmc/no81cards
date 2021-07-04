--四糸乃 开心幻想
local m=33400510
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()  
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,m)
	e0:SetCost(cm.cost)
	e0:SetTarget(cm.destg)
	e0:SetOperation(cm.desop)
	c:RegisterEffect(e0)
 --to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+10000)
	e1:SetTarget(cm.tetg)
	e1:SetOperation(cm.teop)
	c:RegisterEffect(e1)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6341,0x3344)
end

function cm.desfilter(c,e,tp)
	return  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp,Group.FromCards(c))
end
function cm.spfilter(c,e,tp,dg)
	local tc=dg:GetFirst()
	return   (c:IsSetCard(0x341) or c:IsAttribute(ATTRIBUTE_WATER)) and ((c:IsLocation(LOCATION_EXTRA) and  c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,dg,c)>0 ) or (c:IsLocation(LOCATION_HAND) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or tc:GetSequence()<5)))   and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.spfilter2(c,e,tp)
	return   (c:IsSetCard(0x341) or c:IsAttribute(ATTRIBUTE_WATER)) 
	and ( (c:IsLocation(LOCATION_EXTRA) and  c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 ) 
	or (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)  )   
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,e,tp,c)  end
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x341)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end