--闪蝶幻乐手 极强音
function c9911465.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFun2(c,c9911465.ffilter1,c9911465.ffilter2,true)
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
	e2:SetTarget(c9911465.sprtg)
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
function c9911465.ffilter1(c)
	return c:IsLevelBelow(6) and c:IsFusionSetCard(0x3952) and not (c:IsOnField() and not c:IsLocation(LOCATION_MZONE))
end
function c9911465.ffilter2(c)
	return c:IsOnField() and c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetOriginalAttribute()&(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)~=0
end
function c9911465.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c9911465.sprfilter1(c,sc)
	return c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
		and (c9911465.ffilter1(c) or c9911465.ffilter2(c))
end
function c9911465.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and aux.gffcheck(g,c9911465.ffilter1,nil,c9911465.ffilter2,nil)
end
function c9911465.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,c)
	return g:CheckSubGroup(c9911465.sprfilter2,2,2,tp,c)
end
function c9911465.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c9911465.sprfilter2,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c9911465.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	if sg:IsExists(Card.IsFacedown,1,nil) then
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_SPSUMMON+REASON_MATERIAL)
	sg:DeleteGroup()
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
	if not (Duel.IsPlayerCanSSet(tp,c) and not c:IsForbidden()) then return false end
	return c:IsLocation(LOCATION_HAND) or (c:IsSetCard(0x3952) and c:IsRace(RACE_FIEND))
end
function c9911465.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9911465.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if not Duel.Equip(tp,tc,c,false) then return end
	if tc:IsPreviousLocation(LOCATION_DECK) then Duel.ConfirmCards(1-tp,tc) end
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9911465.eqlimit)
	tc:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetValue(800)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
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
