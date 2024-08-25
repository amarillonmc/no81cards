--红☆魔☆馆 七曜的魔法使
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82800331)
	aux.AddMaterialCodeList(c,82800331)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1108)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.regcon)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
end
function s.fselect(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.ffilter(c,fc,sub,mg,sg)
	if not (c:IsFusionCode(82800331) or c:IsFusionSetCard(0x868)) then return end
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsFusionCode,1,nil,82800331) and sg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))
			and mg:Filter(Card.IsFusionSetCard,nil,0x868):CheckSubGroup(s.fselect,2,2)
end
function s.matchfilter2(c,g)
	if not c:IsFusionCode(82800331) then return end
	return g:CheckSubGroup(s.fselect,2,2)
end
function s.matchfilter(c,fc,sub,mg,ag)
	if not c:IsFusionSetCard(0x868) then return end
	return not sg or not ag:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dr,des=e:GetLabel()
	if chk==0 then return dr and des and Duel.IsPlayerCanDraw(tp,dr) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,dr,tp,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dr)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local dr,des=e:GetLabel()
	if Duel.Draw(tp,dr,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,des,des,nil)
		if #g==des then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=mg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	e:GetLabelObject():SetLabel(#mg1,#mg2)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetMaterial()
	if cg:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_LIGHT) then
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(1126)
		e3:SetCategory(CATEGORY_COUNTER)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCost(s.ctcost)
		e3:SetTarget(s.cttg)
		e3:SetOperation(s.ctop)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
	if cg:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DARK) then
		--cannot target
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(s.indcon)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(aux.tgoval)
		c:RegisterEffect(e4)
		--indes
		local e5=e4:Clone()
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e5:SetValue(aux.indoval)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end
function s.costfilter(c)
	return aux.IsCodeListed(c,82800331) and c:IsAbleToGraveAsCost()
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1868,1) and c:GetCounter(0x1868)==0
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:AddCounter(0x1868,1)
	end
end
function s.indfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
