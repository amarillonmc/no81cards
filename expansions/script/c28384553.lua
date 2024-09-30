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
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28384553.hspcon)
	e0:SetOperation(c28384553.hspop)
	c:RegisterEffect(e0)
	--indes
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c28384553.valcheck)
	c:RegisterEffect(ce1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28384553.regcon)
	e1:SetOperation(c28384553.regop)
	e1:SetLabelObject(ce1) 
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c28384553.dstg)
	e2:SetOperation(c28384553.dsop)
	c:RegisterEffect(e2)
	--L'Antica SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
	--L'Antica Race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(RACE_FIEND)
	c:RegisterEffect(e4)
end
function c28384553.mfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFusionSetCard(0x285)
end
function c28384553.matfilter(c)
	return c:IsAbleToExtraAsCost() and c:IsFusionSetCard(0x285) and c:IsCanBeFusionMaterial()
end
function c28384553.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28384553.matfilter,c:GetOwner(),LOCATION_MZONE,0,nil)
	return mg:GetCount()>=2 and Duel.GetLP(c:GetOwner())<=3000
end
function c28384553.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c28384553.matfilter,tp,LOCATION_MZONE,0,2,99,nil)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c28384553.valcheck(e,c)
	local val=c:GetMaterial():GetClassCount(Card.GetCode)
	e:SetLabel(val)
end
function c28384553.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabelObject():GetLabel()~=0
end
function c28384553.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if vt>=2 then
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		ge1:SetRange(LOCATION_MZONE)
		ge1:SetTargetRange(LOCATION_MZONE,0)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY+RACE_FIEND))
		ge1:SetValue(aux.tgoval)
		c:RegisterEffect(ge1)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		ge2:SetRange(LOCATION_MZONE)
		ge2:SetTargetRange(LOCATION_MZONE,0)
		ge2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY+RACE_FIEND))
		ge2:SetValue(1)
		c:RegisterEffect(ge2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(300*vt)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28384553,0))
	end
end
function c28384553.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c28384553.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28384553.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28384553.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c28384553.ctfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		for sc in aux.Next(dg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
	local lp=Duel.GetLP(tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and lp~=3000 and Duel.SelectYesNo(tp,aux.Stringid(28384553,1)) then
		Duel.BreakEffect()
		Duel.SetLP(tp,3000)
		local val=0
		if lp<3000 then
			val=3000-lp
		else
			val=lp-3000
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(val)
		c:RegisterEffect(e1)
	end
end
