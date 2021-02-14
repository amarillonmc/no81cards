--动物朋友 白虎 ～席卷的风切～
function c33711104.initial_effect(c)
	   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33711104.ffilter,3,false) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711104,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33711104.thtg)
	e1:SetOperation(c33711104.thop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c33711104.desreptg)
	e2:SetOperation(c33711104.desrepop)
	c:RegisterEffect(e2)
end
function c33711104.ffilter(c)
	return c:IsSetCard(0x442)
end
function c33711104.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33711104.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33711104.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33711104.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33711104.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.ConfirmCards(1-tp,sg)
			if sg:GetClassCount(Card.GetCode)==sg:GetCount() then
					Duel.Draw(tp,1,REASON_DESTROY)
			end
		end
	end
end
function c33711104.repfilter(c)
	return c:IsSetCard(0x442)
		and c:IsDiscardable(REASON_EFFECT)
end
function c33711104.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c33711104.repfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c33711104.repfilter,tp,LOCATION_HAND,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c33711104.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_DISCARD+REASON_EFFECT+REASON_REPLACE)
end