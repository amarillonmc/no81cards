--狂野伯吉斯异兽·寒武耙虾
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd4),2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--发动陷阱
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTarget(s.desreptg)
	e3:SetValue(s.desrepval)
	e3:SetOperation(s.desrepop)
	c:RegisterEffect(e3)
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end


function s.cfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.filter(c,tp)
	return c:IsSetCard(0xd4) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local tc = nil
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			tc = g:GetFirst()
		end
	end
	if tc and tc:CheckActivateEffect(false,true,false)~=nil 
		and Duel.SelectYesNo(tp,aux.Stringid(id,0))  
	then
		Duel.BreakEffect()
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		Duel.ClearOperationInfo(0)
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end		
	end
end



function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and not c:IsReason(REASON_REPLACE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
