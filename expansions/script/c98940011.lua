--彼方的星因士
function c98940011.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--to field
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98940011,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e7:SetCondition(c98940011.condition1)
	e7:SetCost(c98940011.spcost)
	e7:SetTarget(c98940011.tftg)
	e7:SetOperation(c98940011.tfop)
	c:RegisterEffect(e7)
--effect gain1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940011,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetTarget(c98940011.sumtg)
	e2:SetOperation(c98940011.sumop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c98940011.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
--effect gain2
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(98940011,2))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(c98940011.sptg)
	e12:SetOperation(c98940011.spop)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e13:SetRange(LOCATION_FZONE)
	e13:SetTargetRange(LOCATION_MZONE,0)
	e13:SetTarget(c98940011.eftg)
	e13:SetLabelObject(e12)
	c:RegisterEffect(e13)
--effect gain3
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98940011,3))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98940011.con)
	e0:SetTarget(c98940011.tg)
	e0:SetOperation(c98940011.op)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_FZONE)
	e33:SetTargetRange(LOCATION_EXTRA,0)
	e33:SetTarget(c98940011.eftg1)
	e33:SetLabelObject(e0)
	c:RegisterEffect(e33)
--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c98940011.splimit)
	c:RegisterEffect(e4)
 --end turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940011,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CUSTOM+98940011)
	e2:SetCondition(c98940011.condition)
	e2:SetOperation(c98940011.operation)
	c:RegisterEffect(e2)
	if not c98940011.global_check then
		c98940011.global_check=true
		c98940011[0]=0
		c98940011[1]=0
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetCondition(c98940011.sspcon)
		ge3:SetOperation(c98940011.checkop)
		Duel.RegisterEffect(ge3,0)
	end
end
function c98940011.splimit(e,c)
	return not (c:IsRank(4) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsLocation(LOCATION_EXTRA)
end
function c98940011.xyzfilter1(c,e)
	return c:IsSetCard(0x9c) and not c:IsSetCard(0x109c) and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(e:GetHandler()) and Duel.GetMZoneCount(c:GetControler(),c,c:GetControler())>0
end
function c98940011.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c98940011.xyzfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil,e)
end
function c98940011.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(c98940011.xyzfilter1,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c98940011.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end  
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)  
	mg:DeleteGroup()
end
function c98940011.eftg1(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109c)
end
function c98940011.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function c98940011.sspcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c98940011.sspcon(e,tp,eg,ep,ev,re,r,rp)
	local ts=e:GetHandler():GetOwner()
	return eg and eg:IsExists(c98940011.sspcfilter,1,nil,ts)
end
function c98940011.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c98940011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940011.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c98940011.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c98940011.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(98940011)==0 end
	c:RegisterFlagEffect(98940011,RESET_CHAIN,0,1)
end
function c98940011.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c98940011.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x9c)
end
function c98940011.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c98940011.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then 
	   Duel.Summon(tp,c,true,nil)
	end
end
function c98940011.mfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c98940011.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c98940011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c98940011.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c98940011.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98940011.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98940011.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c98940011.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,6)
	end
end
function c98940011.spcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSetCard(0x9c)
end
function c98940011.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ts=e:GetHandler():GetOwner()
	return eg and eg:IsExists(c98940011.spcfilter,1,nil,ts)
end
function c98940011.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9c) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(c98940011.bfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c)
end
function c98940011.bfilter(c,tc)
	return tc:IsCode(c:GetCode()) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c98940011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98940011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98940011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98940011.esspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98940011)>=3
end
function c98940011.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ts=e:GetHandler():GetOwner()
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:IsSummonPlayer(ts) then
			p1=true
			break
		end
		tc=eg:GetNext()
	end
	if p1 then
		c98940011[ts]=c98940011[ts]+1
		if c98940011[ts]==7 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+98940011,e,0,0,0,0)
		end
	end
end
function c98940011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98940011.operation(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,turnp)
end