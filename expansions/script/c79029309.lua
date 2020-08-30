--拉普兰德·斗争血脉收藏-典雅噩兆
function c79029309.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79029309.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL):SetValue(SUMMON_TYPE_FUSION)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029309.splimit)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029026)
	c:RegisterEffect(e2)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029309.val)
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c79029309.egcon)
	e4:SetOperation(c79029309.egop)
	c:RegisterEffect(e4) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c79029309.ccon)
	e5:SetOperation(c79029309.cop)
	c:RegisterEffect(e5)
end
function c79029309.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function c79029309.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c79029309.val(e,c)
	return c:GetMaterial():GetSum(Card.GetBaseAttack)
end
function c79029309.egcon(e,tp,eg,ep,ev,re,r,rp)
	local xp=e:GetHandler():GetOwner()
	return e:GetHandler():GetPreviousControler()~=xp and Duel.GetLocationCount(1-xp,LOCATION_MZONE)>0 
end
function c79029309.egop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
	Debug.Message("对对，就是这样，解放更多的力量吧，你该这样做！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029309,1))
	Duel.BreakEffect()
	local mg=c:GetMaterial()
	local typ=0
	local tc=mg:GetFirst()
	while tc do
	typ=bit.bor(typ,tc:GetRace())
	tc=mg:GetNext()
	end
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetTargetRange(1,1)
	e2:SetLabel(typ)
	e2:SetTarget(c79029309.xsplimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	e:GetHandler():SetHint(CHINT_RACE,typ)
	end
end
function c79029309.xsplimit(e,c)
	local typ=e:GetLabel()
	return bit.band(typ,c:GetRace())~=0
end
function c79029309.ccon(e,tp,eg,ep,ev,re,r,rp)
	local xp=e:GetHandler():GetOwner()
	return e:GetHandler():GetMaterial():IsExists(Card.IsControler,1,nil,1-xp)
end
function c79029309.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("暴虐的恶人阻断正义的道路，我的主人啊，以复仇与恶意为名，引领弱小的人吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029309,0))
	Duel.GetControl(c,1-tp)

end



