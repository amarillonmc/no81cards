--Protoss·高阶圣堂武士
function c65870040.initial_effect(c)
	--连接
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3a37),2,3)
	--连接召唤效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65870040)
	e1:SetTarget(c65870040.target1)
	e1:SetOperation(c65870040.activate1)
	c:RegisterEffect(e1)
end

function c65870040.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x3a37) and c:IsSSetable() and aux.NecroValleyFilter()
end
function c65870040.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870040.stfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c65870040.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65870040.stfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(65870000,0))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		end
	end
end