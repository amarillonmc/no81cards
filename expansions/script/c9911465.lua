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
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCost(c9911465.descost)
	e3:SetTarget(c9911465.destg)
	e3:SetOperation(c9911465.desop)
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
	return c:IsFusionSetCard(0x3952)
end
function c9911465.ffilter2(c)
	return c:IsRace(RACE_FIEND) or (c:IsLocation(LOCATION_SZONE) and bit.band(c:GetOriginalRace(),RACE_FIEND)~=0)
end
function c9911465.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and Duel.GetFlagEffect(sp,9911465)==0
end
function c9911465.sprfilter1(c,sc)
	return c:IsAbleToGraveAsCost() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and (c9911465.ffilter1(c) or c9911465.ffilter2(c))
end
function c9911465.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and aux.gffcheck(g,c9911465.ffilter1,nil,c9911465.ffilter2,nil)
end
function c9911465.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_ONFIELD,0,nil,c)
	return g:CheckSubGroup(c9911465.sprfilter2,2,2,tp,c) and Duel.GetFlagEffect(tp,9911465)==0
end
function c9911465.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9911465.sprfilter1,tp,LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9911465.sprfilter2,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c9911465.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(9911465,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	local sg=e:GetLabelObject()
	if sg:IsExists(Card.IsFacedown,1,nil) then
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoGrave(sg,REASON_SPSUMMON)
	sg:DeleteGroup()
end
function c9911465.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=c:GetReasonEffect()
	if (se and se:IsHasType(EFFECT_TYPE_ACTIONS)) or c:GetFlagEffect(9911465)>0 then
		Duel.RegisterFlagEffect(tp,9911465,RESET_PHASE+PHASE_END,0,1)
	end
	e:GetLabelObject():SetLabel(Duel.GetCurrentChain())
end
function c9911465.costfilter(c)
	return c:IsSetCard(0x3952) and c:IsAbleToGraveAsCost()
end
function c9911465.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911465.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gffcheck,2,2,Card.IsLocation,LOCATION_HAND,Card.IsLocation,LOCATION_DECK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.gffcheck,false,2,2,Card.IsLocation,LOCATION_HAND,Card.IsLocation,LOCATION_DECK)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c9911465.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) end
end
function c9911465.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if ct==0 or #tg<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=tg:Select(tp,ct,ct,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
