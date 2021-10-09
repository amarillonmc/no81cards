--fate·提亚马特
function c9981591.initial_effect(c)
	c:EnableReviveLimit()
--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9981591.efilter)
	c:RegisterEffect(e2)
  --atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9981591.atkval)
	c:RegisterEffect(e4)
 --token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981591,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c9981591.tkcon)
	e3:SetTarget(c9981591.tktg)
	e3:SetOperation(c9981591.tkop)
	c:RegisterEffect(e3)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981591.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981591.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981591,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9981591,1))
end 
function c9981591.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9981591.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end
function c9981591.tkcon(e,tp,eg,ep,ev,re,r,rp)
	 local ph=Duel.GetCurrentPhase()
	 return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9981591.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9950972,0xba5,0x4011,4000,4000,1,RACE_FIEND,ATTRIBUTE_DARK) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c9981591.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,9950972,0xba5,0x4011,4000,4000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,9950972)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		token:RegisterFlagEffect(9981591,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
end