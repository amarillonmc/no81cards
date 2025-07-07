--炯眼蓝怪盗
local s,id,o=GetID()
function s.initial_effect(c)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.remcon)
	e6:SetOperation(s.remop)
	c:RegisterEffect(e6)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(id)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCountLimit(1,id+1000)
	c:RegisterEffect(e3)
end
function s.remfilter(c)
	return c:IsFaceup() and c:IsReason(REASON_EFFECT)
end
function s.remcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xc30) and rp==tp and eg:IsExists(s.remfilter,1,nil)
end
function s.rmfilter(c,mg)
	return c:IsAbleToRemove() and mg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local rmg1=eg:Filter(s.remfilter,nil):Filter(Card.IsControler,nil,tp)
	local rmg2=eg:Filter(s.remfilter,nil):Filter(Card.IsControler,nil,1-tp)
	local og=Group.CreateGroup()
	if #rmg1>0 then
		local cg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0)
		Duel.ConfirmCards(1-tp,cg:Filter(Card.IsFacedown,nil))
		og:Merge(cg:Filter(s.rmfilter,nil,rmg1))
	end
	if #rmg2>0 then
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
		Duel.ConfirmCards(tp,cg:Filter(Card.IsFacedown,nil))
		og:Merge(cg:Filter(s.rmfilter,nil,rmg2))
	end
	Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
end
