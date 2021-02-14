--哥伦比亚·近卫干员-山
function c79029373.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029373.ffilter,2,99,false)   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c79029373.atkcon)
	e1:SetTarget(c79029373.atktg)
	e1:SetOperation(c79029373.atkop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,79029373)
	e2:SetTarget(c79029373.sptg)
	e2:SetOperation(c79029373.spop)
	c:RegisterEffect(e2)
	--to deck 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029373)
	e3:SetCondition(c79029373.tdcon)
	e3:SetTarget(c79029373.tdtg)
	e3:SetOperation(c79029373.tdop)
	c:RegisterEffect(e3)
	--cannot target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(1)
	c:RegisterEffect(e9)


end
function c79029373.ffilter(c,fc,sub,mg,sg)  
	return c:IsType(TYPE_LINK) and (not sg or sg:IsExists(Card.IsSetCard,1,nil,0xa900)) and (not sg or sg:GetSum(Card.GetLink)>=5)
end
function c79029373.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029373.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler()):GetSum(Card.GetBaseAttack)>0 end
end
function c79029373.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c):GetSum(Card.GetBaseAttack)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	Debug.Message("热身结束了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029373,2))
	end
end
function c79029373.spfil(c,e,tp,zone)
	 return c:GetPreviousControler()==1-tp and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,zone)
end
function c79029373.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local zone=e:GetHandler():GetLinkedZone()
	 if chk==0 then return eg:IsExists(c79029373.spfil,1,nil,e,tp,zone) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c79029373.spop(e,tp,eg,ep,ev,re,r,rp)
	 local zone=e:GetHandler():GetLinkedZone()
	 local g=eg:Filter(c79029373.spfil,nil,e,tp,zone) 
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	 Debug.Message("既然我来带队，就要服从我。")
	 Duel.Hint(HINT_SOUND,0,aux.Stringid(79029373,0))
	 local sg=g:Select(tp,1,1,nil)
	 Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP,zone)
end
function c79029373.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c79029373.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c79029373.tdop(e,tp,eg,ep,ev,re,r,rp)
	 Debug.Message("你们没吃饭吗？用点力气。")
	 Duel.Hint(HINT_SOUND,0,aux.Stringid(79029373,1))
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local x=Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RULE)
	Duel.BreakEffect()
	Duel.Damage(1-tp,x*800,REASON_EFFECT)
	end
end









