--逢魔龙-王时裂破
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(s.sumcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_FUSION) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,0,0,0)
		end
		if tc:IsType(TYPE_SYNCHRO) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id+o*10000,0,0,0)
		end
		if tc:IsType(TYPE_XYZ) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id+o*20000,0,0,0)
		end
		if tc:IsType(TYPE_LINK) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id+o*30000,0,0,0)
		end
		if tc:IsType(TYPE_PENDULUM) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id+o*40000,0,0,0)
		end
	end
end
function s.sumcon(e)
	return not (Duel.GetFlagEffect(tp,id)>0
		and Duel.GetFlagEffect(tp,id+o*10000)>0
		and Duel.GetFlagEffect(tp,id+o*20000)>0
		and Duel.GetFlagEffect(tp,id+o*30000)>0
		and Duel.GetFlagEffect(tp,id+o*40000)>0)
end
function s.spfilter(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.cfilter(c,ec)
	local ect=bit.band(ect:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
	local ct=bit.band(ct:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
	return c:IsFaceupEx() and bit.band(ect,ct)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.tfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) and c:IsFaceup()
end
function s.skipfilter(c,g)
	local sg=Group.FromCards(c)
	local res=false
	if c:IsType(TYPE_PENDULUM) then
		res=g:IsExists(s.skipfilter2,1,sg,g,sg)
	end
	sg:RemoveCard(c)
	return res
end
function s.skipfilter2(c,g,sg)
	sg:AddCard(c)
	local res=false
	if c:IsType(TYPE_FUSION) then
		res=g:IsExists(s.skipfilter3,1,sg,g,sg)
	end
	sg:RemoveCard(c)
	return res
end
function s.skipfilter3(c,g,sg)
	sg:AddCard(c)
	local res=false
	if c:IsType(TYPE_SYNCHRO) then
		res=g:IsExists(s.skipfilter4,1,sg,g,sg)
	end
	sg:RemoveCard(c)
	return res
end
function s.skipfilter4(c,g,sg)
	sg:AddCard(c)
	local res=false
	if c:IsType(TYPE_XYZ) then
		res=g:IsExists(s.skipfilter5,1,sg,g,sg)
	end
	sg:RemoveCard(c)
	return res
end
function s.skipfilter5(c,g,sg)
	return c:IsType(TYPE_LINK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_MZONE,0,nil)
		if g:IsExists(s.skipfilter,1,nil,g) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetTargetRange(0,1)
			local rct=1
			if Duel.GetTurnPlayer()==1-tp then rct=2 end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
			Duel.RegisterEffect(e1,tp)
		end
	end
end