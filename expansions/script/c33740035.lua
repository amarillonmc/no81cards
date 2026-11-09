--静流想要做Protoform！
function c33740035.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c33740035.lcheck)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c33740035.tkcon)
	e1:SetTarget(c33740035.tktg)
	e1:SetOperation(c33740035.tkop)
	c:RegisterEffect(e1)
	--spsummon biiig token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33740035.destg)
	e2:SetOperation(c33740035.desop)
	c:RegisterEffect(e2)
end
function c33740035.mfilter(c)
	return c:IsSetCard(0x6440) and c:IsLevelBelow(4)
end
function c33740035.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TOKEN) or g:IsExists(c33740035.mfilter,1,nil)
end
function c33740035.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSequence()>4
end
function c33740035.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c33740035.tkop(e,tp,eg,ep,ev,re,r,rp)
	--limit
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c33740035.ptfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	--token
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local zone=c:GetLinkedZone(tp)&0x1f
	if zone==0 then return end
	for i=1,3 do
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER) or (i>1 and (Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.SelectYesNo(tp,aux.Stringid(33740035,1)))) then
			break
		end
		local token=Duel.CreateToken(tp,33720265)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone) then
			aux.CannotBeTributeOrMaterial(token,true,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE)
		end
	end
	Duel.SpecialSummonComplete()
end
function c33740035.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	if chk==0 then return g:CheckSubGroup(aux.mzctcheck,1,#g,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER) or Duel.GetMZoneCount(1-tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c33740035.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,nil,TYPE_TOKEN)
	if not tg or #tg==0 then return end
	Duel.HintSelection(tg)
	if Duel.Destroy(tg,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local atk,def=og:GetSum(Card.GetPreviousAttackOnField),tg:GetSum(Card.GetPreviousDefenseOnField)
	local b1=Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
	local b2=Duel.GetMZoneCount(1-tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33720265,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP,1-tp)
	if not (b1 or b2) then return end
	local p=b1 and tp or 1-tp
	if b1 and b2 then
		p=Duel.SelectOption(tp,aux.Stringid(33740035,2),aux.Stringid(33740035,3))==0 and tp or 1-tp
	end
	local token=Duel.CreateToken(tp,33720265)
	if Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP) then
		aux.CannotBeTributeOrMaterial(token,true,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(atk)
		--e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c33740035.ptfilter(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function Auxiliary.CannotBeTributeOrMaterial(c,f,forced,reset,prop)
	if f and type(f)~="function" then
		f,forced,reset,prop=nil,f,forced,reset
	end
	local prop=prop or 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|prop)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	if f==nil then
		e1:SetValue(1)
	else
		e1:SetValue(Auxiliary.FilterToCannotValue(f))
	end
	if reset then
		e1:SetReset(reset)
	end
	c:RegisterEffect(e1,forced)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2:SetValue(1)
	c:RegisterEffect(e2,forced)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|prop)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	if f==nil then
		e3:SetValue(1)
	else
		e3:SetValue(Auxiliary.FilterToCannotValue(f))
	end
	if reset then
		e3:SetReset(reset)
	end
	c:RegisterEffect(e3,forced)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4,forced)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5,forced)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6,forced)
end
