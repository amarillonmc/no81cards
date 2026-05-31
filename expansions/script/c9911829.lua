--烬灵永世之王-烛火尽
function c9911829.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),2,99,c9911829.lcheck)
	c:EnableReviveLimit()
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c9911829.atkcon)
	e1:SetTarget(c9911829.atktg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,9911829)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9911829.negcon)
	e2:SetCost(c9911829.negcost)
	e2:SetTarget(c9911829.negtg)
	e2:SetOperation(c9911829.negop)
	c:RegisterEffect(e2)
	if not c9911829.global_check then
		c9911829.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c9911829.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911829.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_GRAVE~=0
		and rc:IsRelateToEffect(re) and rc:GetFlagEffect(9911829)==0 then
		rc:RegisterFlagEffect(9911829,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911829,0))
	end
end
function c9911829.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa957)
end
function c9911829.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa957) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9911829.atkcon(e)
	local b1=e:GetHandler():IsLocation(LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(c9911829.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
	local b2=e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
	return b1 or b2
end
function c9911829.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c9911829.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainNegatable(ev)
end
function c9911829.rfilter(c)
	return c:GetFlagEffect(9911829)>0
end
function c9911829.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,3,3,nil)
	local rg=g:Filter(c9911829.rfilter,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if #rg>0 then
		local fid=e:GetHandler():GetFieldID()
		for tc in aux.Next(rg) do
			tc:RegisterFlagEffect(9911830,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,fid,aux.Stringid(9911829,0))
		end
		rg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetLabelObject(rg)
		e1:SetCondition(c9911829.thcon)
		e1:SetOperation(c9911829.thop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911829.thfilter(c,fid)
	return c:GetFlagEffectLabel(9911830)==fid
end
function c9911829.thcon(e,tp,eg,ep,ev,re,r,rp)
	local laba,labb=e:GetLabel()
	local g=e:GetLabelObject()
	if not g:IsExists(c9911829.thfilter,1,nil,laba) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnCount()==labb+1 end
end
function c9911829.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911829)
	local laba,labb=e:GetLabel()
	local g=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,c9911829.thfilter,1,1,nil,laba)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_COST)
	end
	g:DeleteGroup()
end
function c9911829.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9911829.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
