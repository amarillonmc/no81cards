--女儿们的国度
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98346578+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98346578.activate)
	c:RegisterEffect(e1)
	--Atk&Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf7))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98346578.mtcon)
	e4:SetOperation(c98346578.mtop)
	c:RegisterEffect(e4)
end
function c98346578.setfilter(c)
	return c:IsSetCard(0xaf7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(98346578)
end
function c98346578.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98346578.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98346578,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sg)
	end
end
function c98346578.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98346578.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c98346578.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(c98346578.cfilter,tp,LOCATION_DECK,0,nil)
	local sel=1
	if g:GetCount()>=3 then
		sel=Duel.SelectOption(tp,aux.Stringid(98346578,1),aux.Stringid(98346578,2))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(98346578,2))+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:Select(tp,3,3,nil)
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Destroy(c,REASON_COST)
	end
end