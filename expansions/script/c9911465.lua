--闪蝶幻乐手 极强音
function c9911465.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3952),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9911465.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9911465.sprcon)
	e2:SetOperation(c9911465.sprop)
	c:RegisterEffect(e2)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c9911465.eqtg)
	e3:SetOperation(c9911465.eqop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c9911465.sucop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c9911465.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c9911465.sprfilter1(c,sc)
	return c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and not c:IsFusionType(TYPE_FUSION)
		and (c:IsFusionSetCard(0x3952) or c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
end
function c9911465.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:IsExists(Card.IsRace,1,nil,RACE_FIEND)
		and aux.gffcheck(g,Card.IsFusionSetCard,0x3952,Card.IsFusionAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9911465.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	return g:CheckSubGroup(c9911465.sprfilter2,2,2,tp,c)
end
function c9911465.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c9911465.sprfilter2,false,2,2,tp,c)
	c:SetMaterial(sg)
	if sg:IsExists(Card.IsFacedown,1,nil) then
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_SPSUMMON+REASON_MATERIAL)
end
function c9911465.sucop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(Duel.GetCurrentChain())
end
function c9911465.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	if ct>0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) end
end
function c9911465.eqfilter(c,tp)
	return c:IsSetCard(0x3952) and c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanSSet(tp,c) and not c:IsForbidden()
end
function c9911465.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9911465.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if not Duel.Equip(tp,tc,c,false) then return end
	Duel.ConfirmCards(1-tp,tc)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9911465.eqlimit)
	tc:RegisterEffect(e1)
	local ct=e:GetLabel()
	local tg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if ct==0 or #tg<ct then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=tg:Select(tp,ct,ct,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c9911465.eqlimit(e,c)
	return e:GetOwner()==c
end
