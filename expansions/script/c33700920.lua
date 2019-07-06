--掘地求生
function c33700920.initial_effect(c)
	c:SetUniqueOnField(1,0,33700920)  
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ct
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(33700920,0))
	e8:SetCategory(CATEGORY_COUNTER)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_SZONE)
	e8:SetOperation(c33700920.rtdop)
	c:RegisterEffect(e8) 
	--dam
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_dam)
	e5:SetDescription(aux.Stringid(33700920,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c33700920.damcon)
	e5:SetTarget(c33700920.damtg)
	e5:SetOperation(c33700920.damop)
	c:RegisterEffect(e5)
	e5:SetLabel(0)
	--ssssss
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c33700920.addop)
	c:RegisterEffect(e6)
	e6:SetLabelObject(e5)
	--b2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700920,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c33700920.descost)
	e3:SetTarget(c33700920.destg)
	e3:SetOperation(c33700920.desop)
	c:RegisterEffect(e3)
end
function c33700920.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33700920.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(33700920,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c33700920.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():GetCounter(0x1b)>=30 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end 
function c33700920.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c33700920.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel()*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*500)
end
function c33700920.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c33700920.addop(e)
	local c=e:GetHandler()
	e:GetLabelObject():SetLabel(c:GetCounter(0x1b))
end
function c33700920.rtdop(e,tp)
	local c=e:GetHandler()
	local d1=Duel.TossDice(tp,1)
	local d2=Duel.TossDice(1-tp,1)
	if d1>d2 then
		c:AddCounter(0x1b,d1)
	else
		c:RemoveCounter(tp,0x1b,math.min(c:GetCounter(0x1b),d1),REASON_EFFECT)
		local ct=math.min(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0),d1)
		Duel.DiscardHand(tp,nil,ct,ct,REASON_EFFECT,nil)
	end
end