--赛马娘
local m=91010101
local cm=c91010101
function c91010101.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(cm.tag)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.drcon)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(cm.immcon)
	e4:SetOperation(cm.immop)
	c:RegisterEffect(e4)
end
function cm.fit1(c,tc)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(tc)
end
function cm.fit2(c,tc)
	return not c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(tc)
end
function cm.tgrfilter(c)
	return c:IsFaceup()  and c:IsLevelAbove(1) and c:IsCanBeSynchroMaterial()
end
function cm.mnfilter(c,g,tc)
	return g:IsExists(cm.mnfilter2,1,c,c,tc)
end
function cm.mnfilter2(c,mc,tc)
	local n=tc:GetLevel()
	return c:GetLevel()-mc:GetLevel()==n
end
function cm.fselect(g,tp,tc)
	return  g:IsExists(cm.fit1,1,nil,tc) and g:IsExists(cm.fit2,1,nil,tc)
		and g:IsExists(cm.mnfilter,1,nil,g,tc) 
		and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local tc=e:GetOwner()
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp,c,tc) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_MZONE,0,nil)
	local tc=e:GetOwner()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp,c,tc)
	--Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.SynchroSummon(tp,tg:GetFirst(),c)
end
function cm.tag(e,c)
	return c:IsType(TYPE_SYNCHRO) 
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return  r==REASON_SYNCHRO 
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)   
	Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) or te:IsActiveType(TYPE_SPELL)
end
