--人理代行 观星者藤丸立香
function c22023950.initial_effect(c)
	c:SetSPSummonOnce(22023950)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22023950.matfilter,1,1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023950,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22023950)
	e1:SetTarget(c22023950.sptg)
	e1:SetOperation(c22023950.spop)
	c:RegisterEffect(e1)
	--spsummon 7
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023950,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023951)
	e2:SetCondition(c22023950.con7)
	e2:SetCost(c22023950.spcost1)
	e2:SetTarget(c22023950.sptg1)
	e2:SetOperation(c22023950.spop1)
	c:RegisterEffect(e2)
	--spsummon 15
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023950,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22023951)
	e3:SetCondition(c22023950.con15)
	e3:SetCost(c22023950.spcost2)
	e3:SetTarget(c22023950.sptg2)
	e3:SetOperation(c22023950.spop2)
	c:RegisterEffect(e3)
	--spsummon 7 ere
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023950,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22023951)
	e4:SetCondition(c22023950.con7ere)
	e4:SetCost(c22023950.spcost1ere)
	e4:SetTarget(c22023950.sptg1)
	e4:SetOperation(c22023950.spop1)
	c:RegisterEffect(e4)
	--spsummon 15
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22023950,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,22023951)
	e5:SetCondition(c22023950.con15ere)
	e5:SetCost(c22023950.spcost2ere)
	e5:SetTarget(c22023950.sptg2)
	e5:SetOperation(c22023950.spop2)
	c:RegisterEffect(e5)
	--win
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_ADJUST)
	e6:SetOperation(c22023950.winop)
	c:RegisterEffect(e6)

	if not c22023950.global_flag then
		c22023950.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22023950.regop)
		Duel.RegisterEffect(ge1,0)
		c22023950.global_flag=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c22023950.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c22023950.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0xff1) then
			Duel.RegisterFlagEffect(tp,22023951,0,0,0)
		end
	end
end
function c22023950.matfilter(c)
	return c:IsLinkCode(22020000) 
end
function c22023950.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023951,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,1000,1000,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={0xff1,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023950,6))
end
function c22023950.spop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023951,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,1000,1000,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,22023951)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c22023950.cfilter1(c,tp)
	return c:IsSetCard(0xff1) and Duel.GetMZoneCount(tp,c)>0
end
function c22023950.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22023950.cfilter1,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22023950.cfilter1,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22023950.spfilter1(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023950.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023950.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SelectOption(tp,aux.Stringid(22023950,7))
end
function c22023950.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023950.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22023950.con7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023951)>6 and Duel.GetFlagEffect(tp,22023951)<15
end
function c22023950.con15(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023951)>14 
end
function c22023950.cfilter2(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c22023950.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c22023950.spfilter2(c,e,tp,sc)
	return c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c22023950.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22023950.cfilter2,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c22023950.cfilter2,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c22023950.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023950.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	Duel.SelectOption(tp,aux.Stringid(22023950,7))
end
function c22023950.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023950.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c22023950.con7ere(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023951)>6 and Duel.GetFlagEffect(tp,22023951)<26 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023950.spcost1ere(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22023950.cfilter1,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22023950.cfilter1,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023950.con15ere(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023951)>25 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023950.spcost2ere(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22023950.cfilter2,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c22023950.cfilter2,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c22023950.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DISASTER_LEO=0x1
	if Duel.GetFlagEffect(tp,22023951)>372 then
		Duel.SelectOption(tp,aux.Stringid(22023950,5))
		Duel.Win(tp,WIN_REASON_DISASTER_LEO)
	end
end