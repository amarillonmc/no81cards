--CiXYZ 冀望皇 异晶帝
function c79029535.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,4,c79029535.ovfilter,aux.Stringid(67926903,0),99)
	c:EnableReviveLimit()   
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029535.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029535,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c79029535.cpcost)
	e3:SetTarget(c79029535.cptg)
	e3:SetOperation(c79029535.cpop)
	c:RegisterEffect(e3)
	--Win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c79029535.winop)
	c:RegisterEffect(e4)
end
function c79029535.ovfilter(c)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil then return false end
	local no=class.xyz_number
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x2048)
end
function c79029535.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()*2000
end
function c79029535.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) or Duel.CheckLPCost(tp,400) end
	local b1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b2=Duel.CheckLPCost(tp,400)
	local s=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029535,0),aux.Stringid(79029535,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029535,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(79029535,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
	Duel.PayLPCost(tp,400)
	else
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
end
function c79029535.fil(c)
	return c:IsType(TYPE_XYZ) and c:GetFlagEffect(79029535)==0
end
function c79029535.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029535.fil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c79029535.fil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e)
	local tc=g:GetFirst()
	tc:RegisterFlagEffect(79029535,RESET_PHASE+PHASE_END,0,0)
	Duel.SetTargetCard(tc)  
end
function c79029535.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Overlay(c,tc)~=0 then
	Duel.MajesticCopy(c,tc)
end
end
function c79029535.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_BALIAN = 0x1
	local c=e:GetHandler()
	local a1=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029526)
	local a2=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029556)
	local a3=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029515)
	local a4=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029528)
	local a5=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029555)
	local a6=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029531)
	local a7=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029557)
	local b1=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,12744567)
	local b2=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,67173574)
	local b3=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,20785975)
	local b4=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,49456901)
	local b5=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,85121942)
	local b6=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,55888045)
	local b7=c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,68396121)
	if a1 and a2 and a3 and a4 and a5 and a6 and a7 and b1 and b2 and b3 and b4 and b5 and b6 and b7 then
		Duel.Win(tp,WIN_REASON_BALIAN)
	end
end




