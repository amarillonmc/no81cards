--暴走之折纸使
function c9910014.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3950),2,true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9910014.sprcon)
	e2:SetOperation(c9910014.sprop)
	c:RegisterEffect(e2)
	--mat check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9910014.matcheck)
	c:RegisterEffect(e3)
	--effect indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910014.condtion)
	e4:SetValue(c9910014.valcon)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c9910014.condtion)
	e5:SetValue(c9910014.efilter)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c9910014.destg)
	e6:SetOperation(c9910014.desop)
	c:RegisterEffect(e6)
end
function c9910014.sprfilter1(c,sc)
	return c:IsSetCard(0x3950,0x5950) and c:IsAbleToRemoveAsCost()
		and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9910014.sprfilter2(g,tp,sc)
	return g:IsExists(Card.IsSetCard,1,nil,0x3950) and g:IsExists(Card.IsSetCard,1,nil,0x5950)
		and g:IsExists(Card.IsSetCard,2,nil,0x3950,0x5950) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c9910014.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9910014.sprfilter1,tp,LOCATION_ONFIELD,0,nil,c)
	return g:CheckSubGroup(c9910014.sprfilter2,2,2,tp,c)
end
function c9910014.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9910014.sprfilter1,tp,LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9910014.sprfilter2,false,2,2,tp,c)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9910014.matcheck(e,c)
	local g=c:GetMaterial()
	local res=true
	local tc=g:GetFirst()
	while tc do
		res=res and tc:IsType(TYPE_PENDULUM)
		tc=g:GetNext()
	end
	if res then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c9910014.condtion(e)
	local flag=e:GetLabelObject():GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and flag==1
end
function c9910014.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c9910014.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c9910014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910014.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)~=0
		and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
