--远古造物 风神翼龙
require("expansions/script/c9910700")
function c9910731.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910731,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SSET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9910731.concon)
	e1:SetTarget(c9910731.contg)
	e1:SetOperation(c9910731.conop)
	c:RegisterEffect(e1)
end
function c9910731.concon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c9910731.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)>0 end
end
function c9910731.conop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910731,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910731,4))
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9910731,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910731,4))
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(9910731,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910731,4))
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.ConfirmCards(tp,sg)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
	local c=e:GetHandler()
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910731.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910731.discon)
		e2:SetOperation(c9910731.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910731.distg)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9910731.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910731.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910731.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
