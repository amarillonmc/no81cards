--塔露拉·不死的黑蛇
function c60000086.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,3,c60000086.ovfilter,aux.Stringid(60000086,0),99,c60000086.xyzop)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000086,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c60000086.sprcon)
	e1:SetOperation(c60000086.sprop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000086,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c60000086.jscost)
	e2:SetTarget(c60000086.jstg)
	e2:SetOperation(c60000086.jsop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c60000086.sccon)
	e3:SetTarget(c60000086.sctg)
	e3:SetOperation(c60000086.scop)
	c:RegisterEffect(e3)

	if not c60000086.global_check then
		c60000086.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetRange(LOCATION_EXTRA)
		e4:SetCondition(c60000086.discon)
		e4:SetOperation(c60000086.checkop)
		c:RegisterEffect(e4)
	end

	aux.EnableChangeCode(c,60000064,LOCATION_MZONE+LOCATION_GRAVE)

end
function c60000086.ovfilter(c)
	return c:IsFaceup() and c:IsCode(60000064)
end
function c60000086.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000086)==0 and Duel.GetFlagEffect(tp,90000086)>11 end
	Duel.RegisterFlagEffect(tp,60000086,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c60000086.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c60000086.ovfilter,1,nil) and Duel.GetFlagEffect(tp,90000086)>11
end
function c60000086.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c60000086.ovfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c60000086.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==e:GetHandlerPlayer() and re:GetHandler():IsSetCard(0x3621)
end
function c60000086.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),90000086,0,0,1)
end
function c60000086.jscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c60000086.jster(c)
	return c:IsSetCard(0x3621) and c:IsAbleToHand()
end
function c60000086.jstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000086.jster,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60000086.jsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60000086.jster,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60000086.sccon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x3621)
end
function c60000086.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60000086.scop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if  g:GetCount()==1 then
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g)
	end
end