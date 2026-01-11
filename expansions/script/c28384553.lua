--古之钥的最强音 假面狂欢
function c28384553.initial_effect(c)
	aux.AddFusionProcFunRep2(c,c28384553.mfilter,2,99,true)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	--e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28384553.sprcon)
	e0:SetTarget(c28384553.sprtg)
	e0:SetOperation(c28384553.sprop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c28384553.destg)
	e1:SetOperation(c28384553.desop)
	c:RegisterEffect(e1)
	--material check
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c28384553.valcheck)
	ce1:SetLabelObject(e1)
	c:RegisterEffect(ce1)
	if not ANTICA_EFFECT_HINT then
		ANTICA_EFFECT_HINT = true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c28384553.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28384553.mfilter(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsRace(RACE_FAIRY)
end
function c28384553.matfilter(c)
	return c:IsAbleToExtraAsCost() and c:IsRace(RACE_FAIRY) and c:IsCanBeFusionMaterial()
end
function c28384553.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0
end
function c28384553.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c28384553.matfilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(c28384553.gcheck,2,#mg,tp,c) and Duel.GetLP(tp)<=3000
end
function c28384553.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c28384553.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,c28384553.gcheck,true,2,99,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c28384553.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKTOP,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c28384553.valcheck(e,c)
	local val=c:GetMaterial():GetClassCount(Card.GetCode)
	e:GetLabelObject():SetLabel(val)
end
function c28384553.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28384553.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():IsRelateToChain() and e:GetLabel() or 0
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		end
		Duel.Destroy(sg,REASON_EFFECT)
	end
	local lp=Duel.GetLP(tp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() and lp~=3000 and Duel.SelectYesNo(tp,aux.Stringid(28384553,1)) then
		Duel.BreakEffect()
		Duel.SetLP(tp,3000)
		local val=math.abs(3000-lp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c28384553.checkop(e,tp,eg,ep,ev,re,r,rp)
	local member_list={28316149,28316051,28316558,28315844,28317560}
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsCode,p,0xff,0,nil,table.unpack(member_list))
		if g:GetClassCount(Card.GetCode)==#member_list then
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_CUSTOM+28384553)
			ge1:SetOperation(c28384553.hintop)
			Duel.RegisterEffect(ge1,p)
		end
	end
	e:Reset()
end
function c28384553.hintop(e,tp,eg,ep,ev,re,r,rp)
	--if rp~=tp then return end
	local member_list={28316149,28316051,28316558,28315844,28317560}
	local code_ascver={28315844,28316051,28316149,28316558,28317560}--ascending order
	for _,te in pairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+28384553)}) do te:Reset() end
	for i,code in pairs(member_list) do
		local ct=Duel.GetFlagEffectLabel(tp,code) or 0
		local te=Effect.CreateEffect(e:GetHandler())
		te:SetDescription(aux.Stringid(code_ascver[i],ct+5))
		te:SetType(EFFECT_TYPE_FIELD)
		te:SetCode(EFFECT_FLAG_EFFECT+28384553)
		te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		te:SetTargetRange(1,0)
		te:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(te,p)
	end
end
