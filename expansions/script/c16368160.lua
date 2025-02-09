--光之数码兽 神龙兽·X抗体
function c16368160.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,50222100,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdc3),1,false,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c16368160.splimit)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c16368160.sumsuc)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16368160)
	e2:SetCondition(c16368160.rlcon)
	e2:SetTarget(c16368160.rltg)
	e2:SetOperation(c16368160.rlop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c16368160.atcon)
	e3:SetValue(c16368160.atlimit)
	c:RegisterEffect(e3)
	--direct attack
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD)
	e33:SetCode(EFFECT_DIRECT_ATTACK)
	e33:SetRange(LOCATION_MZONE)
	e33:SetTargetRange(LOCATION_MZONE,0)
	e33:SetCondition(c16368160.atcon)
	e33:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	c:RegisterEffect(e33)
end
function c16368160.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(16364073)
		or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c16368160.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c16368160.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(16368160,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,c:GetFieldID())
end
function c16368160.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsOnField() and rc:GetFlagEffectLabel(16368160)~=e:GetLabel()
end
function c16368160.rlcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c16368160.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,16368170,0,TYPES_TOKEN_MONSTER,1000,0,1,RACE_DRAGON,ATTRIBUTE_FIRE,POS_FACEUP)
	local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,16368175,0,TYPES_TOKEN_MONSTER,0,1000,1,RACE_DRAGON,ATTRIBUTE_WIND,POS_FACEUP)
	local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16368160.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Release(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,16368170,0,TYPES_TOKEN_MONSTER,1000,0,1,RACE_DRAGON,ATTRIBUTE_FIRE,POS_FACEUP)
			local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,16368175,0,TYPES_TOKEN_MONSTER,0,1000,1,RACE_DRAGON,ATTRIBUTE_WIND,POS_FACEUP)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(16368160,1)},{b2,aux.Stringid(16368160,2)})
			if op==1 then
				local token=Duel.CreateToken(tp,16368170)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			elseif op==2 then
				local token=Duel.CreateToken(tp,16368175)
				Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16368160.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,50222100,16364073)
end
function c16368160.atlimit(e,c)
	return not c:IsType(TYPE_TOKEN)
end