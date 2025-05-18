--圣剑作成
function c22022890.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--sum limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(c22022890.sumcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022890,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCountLimit(1,22022890)
	e2:SetCost(c22022890.spcost)
	e2:SetCondition(c22022890.condition)
	e2:SetTarget(c22022890.sptg)
	e2:SetOperation(c22022890.spop)
	c:RegisterEffect(e2)
	if not c22022890.global_flag then
		c22022890.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22022890.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c22022890.regop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetOperation(c22022890.regop2)
		Duel.RegisterEffect(ge3,0)
	end
end
function c22022890.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22020000) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22022890,0,0,0)
		end
	end
end
function c22022890.regop1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22022870) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22022891,0,0,0)
		end
	end
end
function c22022890.regop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22022880) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),22022892,0,0,0)
		end
	end
end
function c22022890.sumcon(e)
	return not (Duel.GetFlagEffect(tp,22022890)>0 and Duel.GetFlagEffect(tp,22022891)>0 and Duel.GetFlagEffect(tp,22022892)>0)
end
function c22022890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c22022890.filter(c,e,tp)
	return c:IsCode(22022900) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22022890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c22022890.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022890.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.SelectOption(tp,aux.Stringid(22022890,1))
	Duel.SelectOption(tp,aux.Stringid(22022890,2))
	Duel.SelectOption(tp,aux.Stringid(22022890,3))
	Duel.SelectOption(tp,aux.Stringid(22022890,4))
	Duel.SelectOption(tp,aux.Stringid(22022890,5))
	Duel.SelectOption(tp,aux.Stringid(22022890,6))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022890.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.SelectOption(tp,aux.Stringid(22022890,7))
			Duel.SelectOption(tp,aux.Stringid(22022890,8))
			Duel.SelectOption(tp,aux.Stringid(22022890,9))
			tc:CompleteProcedure()
		end
	end
end
function c22022890.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>=3
end