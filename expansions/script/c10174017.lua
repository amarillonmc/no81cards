--精神幻象体
function c10174017.initial_effect(c)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10174017,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c10174017.ctcon)
	e1:SetCost(c10174017.ctcost)
	e1:SetTarget(c10174017.cttg)
	e1:SetOperation(c10174017.ctop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10174017.discon)
	e2:SetOperation(c10174017.adjustop)
	c:RegisterEffect(e2)	
	--disable field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCondition(c10174017.discon)
	e3:SetOperation(c10174017.disop)
	c:RegisterEffect(e3) 
end
function c10174017.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT~=0 and rp~=tp
end
function c10174017.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10174017.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,2,1-tp,LOCATION_MZONE)
end
function c10174017.ctop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c10174017.ctcon2)
	e1:SetOperation(c10174017.ctop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10174017.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil)
end
function c10174017.ctop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10174017)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g,tp)
	end
end
function c10174017.disop(e)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	return bit.lshift(0x1,4-seq)*0x10000
end
function c10174017.discon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c10174017.cfilter(c,tp)
	return not c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToChangeControler()
end
function c10174017.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=c:GetColumnGroup():Filter(c10174017.cfilter,nil,tp)
	if #g<=0 then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(10174017,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY+RESET_CONTROL+RESET_DISABLE+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1,fid)
	for tc in aux.Next(g) do
		tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(10174017,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tp)
		e1:SetLabel(fid)
		e1:SetReset(RESET_EVENT+0xec0000)
		e1:SetCondition(c10174017.con)
		tc:RegisterEffect(e1)
	end
	Duel.Readjust()
end
function c10174017.con(e)
	local c,rc=e:GetHandler(),e:GetOwner()
	local tbl={rc:GetFlagEffectLabel(10174017)}
	for _,fid in ipairs(tbl) do
		if fid==e:GetLabel() then return true end
	end
	c:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(c:GetOwner())
	e1:SetReset(RESET_EVENT+0xec0000)
	c:RegisterEffect(e1,true)  
	e:Reset()
	return false
end 