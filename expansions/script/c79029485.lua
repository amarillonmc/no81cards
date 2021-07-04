--能天使·瑟谣浮收藏-机凯行者
function c79029485.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029051)
	c:RegisterEffect(e0) 
	--race
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_MACHINE)
	c:RegisterEffect(e0)	
	--immuse
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029485.iccon)
	e1:SetOperation(c79029485.icop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand and SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,09029485)
	e3:SetTarget(c79029485.tstg)
	e3:SetOperation(c79029485.tsop)
	c:RegisterEffect(e3)
end
function c79029485.ckfil(c,e,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xa900,0x6a19)
end
function c79029485.iccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029485.ckfil,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() and Duel.GetFlagEffect(tp,79029485)==0
end
function c79029485.icop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then 
	Duel.RegisterFlagEffect(tp,79029485,RESET_PHASE+PHASE_END,0,1)
	Debug.Message("出发！让我们像风暴一样碾过去！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029485,0))
	Duel.SendtoGrave(c,REASON_EFFECT)
	local g=eg:Filter(c79029485.ckfil,nil,e,tp)
	g:KeepAlive()
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c79029485.efilter)
	e1:SetLabelObject(g)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	Duel.RegisterEffect(e2,tp)
	end
end
function c79029485.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and e:GetLabelObject():IsContains(te:GetHandler())
end
function c79029485.rhfil(c)
	return c:IsSetCard(0xa900,0x6a19) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
end
function c79029485.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c79029485.rhfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,c79029485.rhfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c79029485.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then 
	Debug.Message("轮到我出场了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029485,1))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029485.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c79029485.splimit(e,c)
	return not c:IsRace(RACE_MACHINE) and not c:IsRace(RACE_CYBERSE)
end



