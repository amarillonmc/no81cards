--银白之都的灰姑娘
local s,id,o=GetID()
function c67201813.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,67201814)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.mvcon2)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	 
end
--
function s.filter1(c)
	return c:IsSetCard(0x667f) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.filter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()==1-tp and not c:IsForbidden()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,c)
	local gg=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tcc=gg:SelectUnselect(nil,tp,false,true,1,1)
	if tc and tcc then
		local ggg=Group.CreateGroup()
		Group.AddCard(ggg,tc)
		Group.AddCard(ggg,tcc)
		ggg:KeepAlive()
		e:SetLabelObject(ggg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ggg=e:GetLabelObject()
	local tc1=ggg:GetFirst()
	local tc2=ggg:GetNext()
	if Duel.MoveToField(tc1,tp,tc1:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc2,tp,tc2:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc2:RegisterEffect(e1)
			--tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc1:RegisterEffect(e2)
		--tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
----
function s.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c67201813.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x667f) and c:IsAbleToHand()
end
function c67201813.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201813.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c67201813.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201813.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
