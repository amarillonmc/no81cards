--佑炎星-秃鹰宁 
function c98920027.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
--synchro limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetValue(c98920027.synlimit)
	c:RegisterEffect(e11)
--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920027,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920027.condition)
	e2:SetTarget(c98920027.target)
	e2:SetOperation(c98920027.operation)
	c:RegisterEffect(e2)
--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c98920027.thtg)
	e1:SetOperation(c98920027.thop)
	e1:SetCountLimit(1,98920027)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e12)
end
function c98920027.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920027.filter(c,tp)
	return c:IsSetCard(0x79) and c:IsControler(tp) and (c:IsSummonType(SUMMON_TYPE_XYZ) or c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_TYPE_LINK) or c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_SYNCHRO))
end
function c98920027.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920027.filter,1,nil,tp)
end
function c98920027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c98920027.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c98920027.setfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(c98920027.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c98920027.setfilter2(c,code)
	return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(code) and c:IsSSetable()
end
function c98920027.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c98920027.setfilter2,tp,LOCATION_DECK,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c98920027.setfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920027.setfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)  and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920027.setfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920027.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c98920027.setfilter2,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
			Duel.SSet(tp,sg)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetTargetRange(1,0)
			e2:SetValue(c98920027.aclimit)
			e2:SetLabel(tc:GetCode())
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)	  
		end
	end
end
function c98920027.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end