--熵渎的天才
function c60157001.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c60157001.ffilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c60157001.splimit)
	c:RegisterEffect(e0)
	--cannot fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60157001,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c60157001.e2tg)
	e2:SetOperation(c60157001.e2op)
	c:RegisterEffect(e2)
	
	--cannot material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c60157001.fuslimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UNRELEASABLE_SUM)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e8)
end

function c60157001.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c60157001.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function c60157001.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c60157001.e2tgf(c,e,tp)
	local atk=c:GetBaseAttack()
	local def=c:GetBaseDefense()
	return c:GetOriginalType()&TYPE_MONSTER~=0 and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60157002,0,TYPES_TOKEN_MONSTER,atk,def,2,RACE_PSYCHO,ATTRIBUTE_WATER,POS_FACEUP,tp)
end
function c60157001.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60157001.e2tgf,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	local g=Duel.GetMatchingGroup(c60157001.e2tgf,tp,LOCATION_MZONE,0,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c60157001.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c60157001.e2tgf,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Release(g,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local c=e:GetHandler()
			if og:GetCount()==0 then return end
			local tc=og:GetFirst()
			local atk=tc:GetBaseAttack()
			local def=tc:GetBaseDefense()
			if Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,60157002,0,TYPES_TOKEN_MONSTER,atk,def,2,RACE_PSYCHO,ATTRIBUTE_WATER,POS_FACEUP,tp) then
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,60157002)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_DEFENSE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UNRELEASABLE_SUM)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e3:SetValue(1)
				token:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e4)
				local e5=e3:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e5:SetValue(c60157001.opfuslimit)
				token:RegisterEffect(e5)
				local e6=e3:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				token:RegisterEffect(e6)
				local e7=e3:Clone()
				e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				token:RegisterEffect(e7)
				local e8=e3:Clone()
				e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				token:RegisterEffect(e8)
				
				local e9=Effect.CreateEffect(c)
				e9:SetType(EFFECT_TYPE_SINGLE)
				e9:SetCode(EFFECT_ADD_TYPE)
				e9:SetValue(TYPE_EFFECT)
				e9:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e9,true)
				
				local code=tc:GetOriginalCode()
				token:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60157001.opfuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end