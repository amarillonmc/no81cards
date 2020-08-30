--狮蝎·时代收藏-无形悼挽
function c79029287.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),3,true)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029015)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029287.lzcon)
	e1:SetTarget(c79029287.lztg)
	e1:SetOperation(c79029287.lzop)
	c:RegisterEffect(e1)	  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1) 
	e2:SetCondition(c79029287.spcon)
	e2:SetTarget(c79029287.sptg)
	e2:SetOperation(c79029287.spop)
	c:RegisterEffect(e2)   
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)  
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetTarget(c79029287.lztg)
	e3:SetOperation(c79029287.lzop)
	c:RegisterEffect(e3)  
		if not c79029287.global_check then
		c79029287.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c79029287.checkop)
		Duel.RegisterEffect(ge1,0)
end 
end
function c79029287.checkop(e,tp,eg,ep,ev,re,r,rp)
	local xp=re:GetHandlerPlayer()
	local flag=Duel.GetFlagEffectLabel(xp,79029287)
	if flag then
	Duel.SetFlagEffectLabel(xp,79029287,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79029287,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c79029287.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029287.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c79029287.lzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(79029287,RESET_EVENT+RESETS_STANDARD,0,1)
	Debug.Message("潜伏，开始......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029287,1))
end
function c79029287.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029287)~=0 and Duel.GetTurnPlayer()~=tp 
end
function c79029287.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c79029287.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffectLabel(1-tp,79029287) or 0
	Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*700)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_CARD,0,79029287)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*700)
	Debug.Message("永别了......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029287,1))
	end
end







